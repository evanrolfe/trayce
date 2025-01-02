import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/agent/gen/api.pb.dart' as pb;
import 'package:ftrayce/common/bloc/agent_network_bridge.dart' as bridge;
import 'package:ftrayce/network/bloc/flow_table_cubit.dart';
import 'package:ftrayce/network/models/flow_request.dart';
import 'package:ftrayce/network/models/flow_response.dart';
import 'package:ftrayce/network/repo/flow_repo.dart';

import '../../support/database.dart';

void main() {
  group('FlowTableCubit', () {
    late bridge.AgentNetworkBridge agentNetworkBridge;
    late FlowTableCubit cubit;

    late TestDatabase testDb;
    late FlowRepo flowRepo;

    setUp(() async {
      testDb = await TestDatabase.instance;
      flowRepo = FlowRepo(db: testDb.db);

      agentNetworkBridge = bridge.AgentNetworkBridge();
      cubit = FlowTableCubit(agentNetworkBridge: agentNetworkBridge, flowRepo: flowRepo);
    });

    tearDown(() {
      agentNetworkBridge.close();
      cubit.close();
      testDb.truncate();
    });

    group('receiving FlowsObserved from the bridge', () {
      test('it saves a request Flow and emits DisplayFlows', () async {
        final flows = [
          pb.Flow(
            uuid: '123e4567-e89b-12d3-a456-426614174000',
            sourceAddr: '192.168.0.1',
            destAddr: '192.168.0.2',
            l4Protocol: 'tcp',
            l7Protocol: 'http',
            httpRequest: pb.HTTPRequest(
              method: 'GET',
              host: '192.168.0.1',
              path: '/',
              httpVersion: '1.1',
              headers: {},
              payload: [], // [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100], // "hello world"
            ),
          ),
        ];

        // Start listening to the stream before emitting
        final states = cubit.stream.take(1).toList();

        agentNetworkBridge.flowsObserved(flows);

        final emittedStates = await states;
        final displayFlows = emittedStates[0] as DisplayFlows;
        final emittedFlows = displayFlows.flows;

        expect(emittedFlows.length, 1);
        expect(emittedFlows[0].uuid, '123e4567-e89b-12d3-a456-426614174000');
        expect(emittedFlows[0].sourceAddr, '192.168.0.1');
        expect(emittedFlows[0].destAddr, '192.168.0.2');
        expect(emittedFlows[0].l4Protocol, 'tcp');
        expect(emittedFlows[0].l7Protocol, 'http');

        final flowReq = emittedFlows[0].request as HttpRequest;
        expect(flowReq.method, 'GET');
        expect(flowReq.host, '192.168.0.1');
        expect(flowReq.path, '/');
        expect(flowReq.httpVersion, '1.1');
        expect(flowReq.headers, {});
        expect(flowReq.body, '');
      });

      test('it saves a request Flow + response Flow and emits DisplayFlows', () async {
        final flows = [
          pb.Flow(
            uuid: '123e4567-e89b-12d3-a456-426614174000',
            sourceAddr: '192.168.0.1',
            destAddr: '192.168.0.2',
            l4Protocol: 'tcp',
            l7Protocol: 'http',
            httpRequest: pb.HTTPRequest(
              method: 'GET',
              host: '192.168.0.1',
              path: '/',
              httpVersion: '1.1',
              headers: {},
              payload: [], // [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100], // "hello world"
            ),
          ),
          pb.Flow(
            uuid: '123e4567-e89b-12d3-a456-426614174000',
            sourceAddr: '192.168.0.1',
            destAddr: '192.168.0.2',
            l4Protocol: 'tcp',
            l7Protocol: 'http',
            httpResponse: pb.HTTPResponse(
              httpVersion: '1.1',
              status: 200,
              statusMsg: 'OK',
              headers: {},
              payload: [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100], // "hello world"
            ),
          ),
        ];

        // Start listening to the stream before emitting
        final states = cubit.stream.take(1).toList();

        agentNetworkBridge.flowsObserved(flows);

        final emittedStates = await states;
        final displayFlows = emittedStates[0] as DisplayFlows;
        final emittedFlows = displayFlows.flows;

        expect(emittedFlows.length, 1);
        expect(emittedFlows[0].uuid, '123e4567-e89b-12d3-a456-426614174000');
        expect(emittedFlows[0].sourceAddr, '192.168.0.1');
        expect(emittedFlows[0].destAddr, '192.168.0.2');
        expect(emittedFlows[0].l4Protocol, 'tcp');
        expect(emittedFlows[0].l7Protocol, 'http');

        final flowReq = emittedFlows[0].request as HttpRequest;
        expect(flowReq.method, 'GET');
        expect(flowReq.host, '192.168.0.1');
        expect(flowReq.path, '/');
        expect(flowReq.httpVersion, '1.1');
        expect(flowReq.headers, {});
        expect(flowReq.body, '');

        final flowResp = emittedFlows[0].response as HttpResponse;
        expect(flowResp.httpVersion, '1.1');
        expect(flowResp.status, 200);
        expect(flowResp.statusMsg, 'OK');
        expect(flowResp.headers, {});
        expect(flowResp.body, 'hello world');
      });
    });
  });
}
