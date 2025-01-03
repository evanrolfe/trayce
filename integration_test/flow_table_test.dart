import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/agent/gen/api.pb.dart' as pb;
import 'package:ftrayce/agent/gen/api.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:uuid/uuid.dart';

import '../test/network/bloc/flow_table_cubit_test.dart';

Future<void> test(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Find and click the Network tab
  final networkTab = find.byIcon(Icons.format_list_numbered);
  await tester.tap(networkTab);
  await tester.pumpAndSettle();

  // Create the GRPC client
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(), // Use this for non-TLS connections
    ),
  );
  final client = TrayceAgentClient(channel);

  // Send flows observed
  final flows = buildFlows();
  try {
    final response = await client.sendFlowsObserved(pb.Flows(flows: flows));
    print('Response received: $response');
  } catch (e) {
    print('Error: $e');
  }
  await tester.pumpAndSettle();

  // Verify the flow appears in the table
  expect(find.text('http'), findsNWidgets(2));
  expect(find.text('10.0.0.1'), findsOneWidget);
  expect(find.text('10.0.0.2'), findsOneWidget);

  // --------------------------------------------------------------------------
  // Click on the 1st row
  // --------------------------------------------------------------------------
  final flowRow = find.text('10.0.0.1').first;
  await tester.tap(flowRow);
  await tester.pumpAndSettle();

  // Verify the request text appears in the top pane
  expect(find.textContaining('POST / HTTP/1.1'), findsOneWidget);
  expect(find.textContaining('user-agent: trayce,app'), findsOneWidget);
  expect(find.textContaining('content-type: application/html'), findsOneWidget);
  expect(find.textContaining('hello world'), findsOneWidget);

  // --------------------------------------------------------------------------
  // Click on the 2nd row
  // --------------------------------------------------------------------------
  final flowRow2 = find.text('20.0.0.2').first;
  await tester.tap(flowRow2);
  await tester.pumpAndSettle();

  // Verify the request text
  expect(find.textContaining('PUT /hello HTTP/1.1'), findsOneWidget);
  expect(find.textContaining('user-agent: trayce,app'), findsOneWidget);
  expect(find.textContaining('content-type: application/html'), findsOneWidget);
  expect(find.textContaining('hello world'), findsOneWidget);

  // Verify the response text
  expect(find.textContaining('HTTP/1.1 200 OK'), findsOneWidget);
  expect(find.textContaining('testheader: ok'), findsOneWidget);
  expect(find.textContaining('hi'), findsOneWidget);

  // --------------------------------------------------------------------------
  // Click on the 3rd row
  // --------------------------------------------------------------------------
  final flowRow3 = find.text('30.0.0.1').first;
  await tester.tap(flowRow3);
  await tester.pumpAndSettle();

  // Verify the request text appears in the top pane
  expect(find.textContaining('GRPC /api.TrayceAgent/SendContainersObserved'), findsOneWidget);
  expect(find.textContaining('content-type: application/grpc'), findsOneWidget);

  // --------------------------------------------------------------------------
  // Click on the 4th row
  // --------------------------------------------------------------------------
  final flowRow4 = find.text('40.0.0.1').first;
  await tester.tap(flowRow4);
  await tester.pumpAndSettle();
  // await Future.delayed(const Duration(seconds: 5));

  // Verify the request text appears in the top pane
  expect(find.textContaining('GRPC /api.TrayceAgent/SendContainersObserved'), findsOneWidget);
  expect(find.textContaining('content-type: application/grpc'), findsOneWidget);

  expect(find.textContaining('testheader: ok'), findsOneWidget);
}

List<pb.Flow> buildFlows() {
  final uuid2 = Uuid().v4();
  final uuid4 = Uuid().v4();

  return [
    //
    // Flow 1
    //
    pb.Flow(
      uuid: Uuid().v4(),
      sourceAddr: '10.0.0.1',
      destAddr: '10.0.0.2',
      l4Protocol: 'tcp',
      l7Protocol: 'http',
      httpRequest: pb.HTTPRequest(
        method: 'POST',
        host: '10.0.0.1',
        path: '/',
        httpVersion: '1.1',
        headers: {
          "user-agent": pb.StringList(values: ["trayce", "app"]),
          "content-type": pb.StringList(values: ["application/html"]),
        },
        payload: [0x68, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64], // "hello world"
      ),
    ),
    pb.Flow(
      uuid: uuid2,
      sourceAddr: '20.0.0.1',
      destAddr: '20.0.0.2',
      l4Protocol: 'tcp',
      l7Protocol: 'http',
      httpRequest: pb.HTTPRequest(
        method: 'PUT',
        host: '20.0.0.2',
        path: '/hello',
        httpVersion: '1.1',
        headers: {
          "user-agent": pb.StringList(values: ["trayce", "app"]),
          "content-type": pb.StringList(values: ["application/html"]),
        },
        payload: [0x68, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64], // "hello world"
      ),
    ),
    //
    // Flow 2
    //
    pb.Flow(
      uuid: uuid2,
      sourceAddr: '20.0.0.1',
      destAddr: '20.0.0.2',
      l4Protocol: 'tcp',
      l7Protocol: 'http',
      httpResponse: pb.HTTPResponse(
        status: 200,
        statusMsg: 'OK',
        httpVersion: '1.1',
        headers: {
          "testheader": pb.StringList(values: ["ok"]),
        },
        payload: [0x68, 0x69], // "hi"
      ),
    ),
    //
    // Flow 3 (GRPC Request)
    //
    pb.Flow(
      uuid: Uuid().v4(),
      sourceAddr: '30.0.0.1',
      destAddr: '30.0.0.2',
      l4Protocol: 'tcp',
      l7Protocol: 'grpc',
      grpcRequest: pb.GRPCRequest(
        path: '/api.TrayceAgent/SendContainersObserved',
        headers: {
          "content-type": pb.StringList(values: ["application/grpc"])
        },
        payload: grpcReqPayload,
      ),
    ), //
    //
    // Flow 4 (GRPC Request)
    //
    pb.Flow(
      uuid: uuid4,
      sourceAddr: '40.0.0.1',
      destAddr: '40.0.0.2',
      l4Protocol: 'tcp',
      l7Protocol: 'grpc',
      grpcRequest: pb.GRPCRequest(
        path: '/api.TrayceAgent/SendContainersObserved',
        headers: {
          "content-type": pb.StringList(values: ["application/grpc"])
        },
        payload: grpcReqPayload,
      ),
    ),
    //
    // Flow 4 (GRPC Response)
    //
    pb.Flow(
      uuid: uuid4,
      sourceAddr: '40.0.0.1',
      destAddr: '40.0.0.2',
      l4Protocol: 'tcp',
      l7Protocol: 'grpc',
      grpcResponse: pb.GRPCResponse(
        headers: {
          "testheader": pb.StringList(values: ["ok"])
        },
        payload: grpcRespPayload,
      ),
    ),
  ];
}
