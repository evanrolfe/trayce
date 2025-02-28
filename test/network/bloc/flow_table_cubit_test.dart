import 'package:flutter_test/flutter_test.dart';
import 'package:trayce/agent/gen/api.pb.dart' as pb;
import 'package:trayce/common/bloc/agent_network_bridge.dart' as bridge;
import 'package:trayce/network/bloc/flow_table_cubit.dart';
import 'package:trayce/network/models/grpc_request.dart';
import 'package:trayce/network/models/grpc_response.dart';
import 'package:trayce/network/models/http_request.dart';
import 'package:trayce/network/models/http_response.dart';
import 'package:trayce/network/models/sql_query.dart';
import 'package:trayce/network/models/sql_response.dart';
import 'package:trayce/network/repo/flow_repo.dart';
import 'package:uuid/uuid.dart';

import '../../support/database.dart';

const grpcReqPayload = [
  0x0a,
  0x32,
  0x0a,
  0x04,
  0x31,
  0x32,
  0x33,
  0x34,
  0x12,
  0x06,
  0x75,
  0x62,
  0x75,
  0x6e,
  0x74,
  0x75,
  0x1a,
  0x0a,
  0x31,
  0x37,
  0x32,
  0x2e,
  0x30,
  0x2e,
  0x31,
  0x2e,
  0x31,
  0x39,
  0x22,
  0x0d,
  0x48,
  0x45,
  0x4c,
  0x4c,
  0x4f,
  0x57,
  0x4f,
  0x52,
  0x4c,
  0x44,
  0x21,
  0x21,
  0x21,
  0x2a,
  0x07,
  0x72,
  0x75,
  0x6e,
  0x6e,
  0x69,
  0x6e,
  0x67
];

const grpcRespPayload = [0x0a, 0x08, 0x73, 0x75, 0x63, 0x63, 0x65, 0x73, 0x73, 0x20];

void main() {
  group('FlowTableCubit', () {
    late bridge.AgentNetworkBridge agentNetworkBridge;
    late FlowTableCubit cubit;

    late TestDatabase testDb;
    late FlowRepo flowRepo;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      testDb = await TestDatabase.instance;
      flowRepo = FlowRepo(db: testDb.db);

      agentNetworkBridge = bridge.AgentNetworkBridge();
      cubit = FlowTableCubit(agentNetworkBridge: agentNetworkBridge, flowRepo: flowRepo);
    });

    tearDownAll(() async {
      await agentNetworkBridge.close();
      await cubit.close();
    });

    tearDown(() => {testDb.truncate()});

    group('receiving FlowsObserved from the bridge', () {
      test('it saves an HTTP request Flow and emits DisplayFlows', () async {
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
        expect(emittedFlows[0].source, '192.168.0.1');
        expect(emittedFlows[0].dest, '192.168.0.2');
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

      test('it saves an HTTP request Flow + response Flow and emits DisplayFlows', () async {
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
        expect(emittedFlows[0].source, '192.168.0.1');
        expect(emittedFlows[0].dest, '192.168.0.2');
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

      test('it saves an SQL query Flow and emits DisplayFlows', () async {
        final flows = [
          pb.Flow(
            uuid: '123e4567-e89b-12d3-a456-426614174000',
            sourceAddr: '192.168.0.1',
            destAddr: '192.168.0.2',
            l4Protocol: 'tcp',
            l7Protocol: 'mysql',
            sqlQuery: pb.SQLQuery(
              query: 'SELECT * FROM users WHERE id = ?',
              params: pb.StringList(values: ["123"]),
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
        expect(emittedFlows[0].source, '192.168.0.1');
        expect(emittedFlows[0].dest, '192.168.0.2');
        expect(emittedFlows[0].l4Protocol, 'tcp');
        expect(emittedFlows[0].l7Protocol, 'mysql');

        final flowReq = emittedFlows[0].request as SQLQuery;
        expect(flowReq.query, 'SELECT * FROM users WHERE id = ?');
        expect(flowReq.params, ["123"]);
      });

      test('it saves an SQL query Flow + response Flow and emits DisplayFlows', () async {
        final flows = [
          pb.Flow(
            uuid: '123e4567-e89b-12d3-a456-426614174000',
            sourceAddr: '192.168.0.1',
            destAddr: '192.168.0.2',
            l4Protocol: 'tcp',
            l7Protocol: 'mysql',
            sqlQuery: pb.SQLQuery(
              query: 'SELECT * FROM users WHERE id = ?',
              params: pb.StringList(values: ["123"]),
            ),
          ),
          pb.Flow(
            uuid: '123e4567-e89b-12d3-a456-426614174000',
            sourceAddr: '192.168.0.1',
            destAddr: '192.168.0.2',
            l4Protocol: 'tcp',
            l7Protocol: 'mysql',
            sqlResponse: pb.SQLResponse(
              columns: pb.StringList(values: ["id", "name", "email"]),
              rows: [
                pb.StringList(values: ["123", "John Doe", "john@example.com"])
              ],
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
        expect(emittedFlows[0].source, '192.168.0.1');
        expect(emittedFlows[0].dest, '192.168.0.2');
        expect(emittedFlows[0].l4Protocol, 'tcp');
        expect(emittedFlows[0].l7Protocol, 'mysql');

        final flowReq = emittedFlows[0].request as SQLQuery;
        expect(flowReq.query, 'SELECT * FROM users WHERE id = ?');
        expect(flowReq.params, ["123"]);

        final flowResp = emittedFlows[0].response as SQLResponse;
        expect(flowResp.columns, ["id", "name", "email"]);
        expect(flowResp.rows.length, 1);
        expect(flowResp.rows[0], ["123", "John Doe", "john@example.com"]);
      });

      test('it saves a GRPC request Flow and emits DisplayFlows', () async {
        final uuid = const Uuid().v4();
        final flows = [
          pb.Flow(
            uuid: uuid,
            sourceAddr: '192.168.0.1',
            destAddr: '192.168.0.2',
            l4Protocol: 'tcp',
            l7Protocol: 'grpc',
            grpcRequest: pb.GRPCRequest(
              path: '/api.TrayceAgent/SendContainersObserved',
              headers: {},
              payload: grpcReqPayload,
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
        expect(emittedFlows[0].uuid, uuid);
        expect(emittedFlows[0].source, '192.168.0.1');
        expect(emittedFlows[0].dest, '192.168.0.2');
        expect(emittedFlows[0].l4Protocol, 'tcp');
        expect(emittedFlows[0].l7Protocol, 'grpc');

        final flowReq = emittedFlows[0].request as GrpcRequest;
        expect(flowReq.path, '/api.TrayceAgent/SendContainersObserved');
        expect(flowReq.headers, {});
        expect(flowReq.body.length, 52);
      });

      test('it saves a GRPC request+response Flows and emits DisplayFlows', () async {
        final uuid = const Uuid().v4();
        final flows = [
          pb.Flow(
            uuid: uuid,
            sourceAddr: '192.168.0.1',
            destAddr: '192.168.0.2',
            l4Protocol: 'tcp',
            l7Protocol: 'grpc',
            grpcRequest: pb.GRPCRequest(
              path: '/api.TrayceAgent/SendContainersObserved',
              headers: {},
              payload: grpcReqPayload,
            ),
          ),
          pb.Flow(
            uuid: uuid,
            sourceAddr: '192.168.0.1',
            destAddr: '192.168.0.2',
            l4Protocol: 'tcp',
            l7Protocol: 'grpc',
            grpcResponse: pb.GRPCResponse(
              headers: {},
              payload: grpcRespPayload,
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
        expect(emittedFlows[0].uuid, uuid);
        expect(emittedFlows[0].source, '192.168.0.1');
        expect(emittedFlows[0].dest, '192.168.0.2');
        expect(emittedFlows[0].l4Protocol, 'tcp');
        expect(emittedFlows[0].l7Protocol, 'grpc');

        final flowReq = emittedFlows[0].request as GrpcRequest;
        expect(flowReq.path, '/api.TrayceAgent/SendContainersObserved');
        expect(flowReq.headers, {});
        expect(flowReq.body.length, 52);

        final flowResp = emittedFlows[0].response as GrpcResponse;
        expect(flowResp.headers, {});
        expect(flowResp.body.length, 10);
      });
    });
  });
}
