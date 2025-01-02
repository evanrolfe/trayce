import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/network/repo/flow_repo.dart';

import '../../support/database.dart';
import '../../support/flow_factory.dart';

void main() {
  late TestDatabase testDb;
  late FlowRepo flowRepo;

  setUp(() async {
    testDb = await TestDatabase.instance;
    flowRepo = FlowRepo(db: testDb.db);
  });

  tearDown(() => testDb.truncate());

  group('FlowRepo', () {
    group('save()', () {
      test('it saves a flow to the database', () async {
        // Create and save a flow
        final flow = buildHttpReqFlow();
        final savedFlow = await flowRepo.save(flow);

        // Query the database directly to verify
        final List<Map<String, dynamic>> results = await testDb.db.query(
          'flows',
          where: 'id = ?',
          whereArgs: [savedFlow.id],
        );

        expect(results.length, 1);

        final dbFlow = results.first;
        expect(dbFlow['uuid'], flow.uuid);
        expect(dbFlow['source_addr'], flow.sourceAddr);
        expect(dbFlow['dest_addr'], flow.destAddr);
        expect(dbFlow['l4_protocol'], flow.l4Protocol);
        expect(dbFlow['l7_protocol'], flow.l7Protocol);
        expect(dbFlow['request_raw'], flow.requestRaw);
        expect(dbFlow['response_raw'], flow.responseRaw);
        expect(dbFlow['created_at'], flow.createdAt.toIso8601String());
      });
    });

    group('getAllFlows()', () {
      test('it retrieves all saved flows', () async {
        // Save a test flow
        final flow = buildHttpReqFlow();
        final savedFlow = await flowRepo.save(flow);

        // Get all flows
        final flows = await flowRepo.getAllFlows();

        expect(flows.length, 1);
        expect(flows.first.id, savedFlow.id);
        expect(flows.first.uuid, flow.uuid);
        expect(flows.first.sourceAddr, flow.sourceAddr);
        expect(flows.first.destAddr, flow.destAddr);
        expect(flows.first.l4Protocol, flow.l4Protocol);
        expect(flows.first.l7Protocol, flow.l7Protocol);
        expect(flows.first.requestRaw, flow.requestRaw);
        expect(flows.first.responseRaw, flow.responseRaw);
        expect(flows.first.createdAt.toIso8601String(), flow.createdAt.toIso8601String());
      });
    });
  });
}
