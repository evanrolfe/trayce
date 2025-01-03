import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/network/models/http_request.dart';
import 'package:ftrayce/network/models/http_response.dart';
import 'package:ftrayce/network/repo/flow_repo.dart';

import '../../support/database.dart';
import '../../support/flow_factory.dart';

void main() {
  late TestDatabase testDb;
  late FlowRepo flowRepo;

  setUpAll(() async {
    testDb = await TestDatabase.instance;
    flowRepo = FlowRepo(db: testDb.db);
  });

  tearDownAll(() async {});

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

      test('it updates the request flow with a response', () async {
        // Create and save a flow
        final flow1 = buildHttpReqFlow(uuid: "test-1234");
        final savedFlow = await flowRepo.save(flow1);

        // Create and save a response flow
        final flow2 = buildHttpRespFlow(uuid: "test-1234");
        await flowRepo.save(flow2);

        // Query the database directly to verify
        final List<Map<String, dynamic>> results = await testDb.db.query(
          'flows',
          where: 'id = ?',
          whereArgs: [savedFlow.id],
        );

        expect(results.length, 1);

        final dbFlow = results.first;
        expect(dbFlow['uuid'], flow1.uuid);
        expect(dbFlow['source_addr'], flow1.sourceAddr);
        expect(dbFlow['dest_addr'], flow1.destAddr);
        expect(dbFlow['l4_protocol'], flow1.l4Protocol);
        expect(dbFlow['l7_protocol'], flow1.l7Protocol);
        expect(dbFlow['request_raw'], flow1.requestRaw);
        expect(dbFlow['response_raw'], flow2.responseRaw);
        expect(dbFlow['created_at'], flow1.createdAt.toIso8601String());
      });
    });

    group('getAllFlows()', () {
      test('it returns a single HTTP request flow', () async {
        // Save a test flow
        final flow = buildHttpReqFlow();
        final savedFlow = await flowRepo.save(flow);

        // Get all flows
        final flows = await flowRepo.getAllFlows();
        final flowReq = flows.first.request as HttpRequest;

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

        expect(flowReq.method, 'GET');
        expect(flowReq.host, '172.17.0.3');
        expect(flowReq.path, '/');
        expect(flowReq.httpVersion, 'HTTP/1.1');
        expect(flowReq.headers, {});
        expect(flowReq.body, '');
      });

      test('it returns a single HTTP request+response flow', () async {
        // Save a test flow
        final flow1 = buildHttpReqFlow(uuid: "test-1234");
        final savedFlow = await flowRepo.save(flow1);

        final flow2 = buildHttpRespFlow(uuid: "test-1234");
        await flowRepo.save(flow2);

        // Get all flows
        final flows = await flowRepo.getAllFlows();
        final flowReq = flows.first.request as HttpRequest;
        final flowResp = flows.first.response as HttpResponse;

        expect(flows.length, 1);
        expect(flows.first.id, savedFlow.id);
        expect(flows.first.uuid, flow1.uuid);
        expect(flows.first.sourceAddr, flow1.sourceAddr);
        expect(flows.first.destAddr, flow1.destAddr);
        expect(flows.first.l4Protocol, flow1.l4Protocol);
        expect(flows.first.l7Protocol, flow1.l7Protocol);
        expect(flows.first.requestRaw, flow1.requestRaw);
        expect(flows.first.responseRaw, flow2.responseRaw);
        expect(flows.first.createdAt.toIso8601String(), flow1.createdAt.toIso8601String());

        expect(flowReq.method, 'GET');
        expect(flowReq.host, '172.17.0.3');
        expect(flowReq.path, '/');
        expect(flowReq.httpVersion, 'HTTP/1.1');
        expect(flowReq.headers, {});
        expect(flowReq.body, '');

        expect(flowResp.httpVersion, 'HTTP/1.1');
        expect(flowResp.status, 200);
        expect(flowResp.statusMsg, 'OK');
        expect(flowResp.headers, {});
        expect(flowResp.body, 'Hello World!');
      });
    });
  });
}
