import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/agent/gen/api.pb.dart' as pb;
import 'package:ftrayce/agent/gen/api.pbgrpc.dart';
import 'package:grpc/grpc.dart';

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
        httpVersion: 'HTTP/1.1',
        headers: {},
        payload: [], // [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100], // "hello world"
      ),
    ),
  ];
  try {
    final response = await client.sendFlowsObserved(pb.Flows(flows: flows));
    print('Response received: $response');
  } catch (e) {
    print('Error: $e');
  }
  await tester.pumpAndSettle();

  // Verify the modal is shown
  expect(find.text('http'), findsOneWidget);
  // expect(find.text('world'), findsOneWidget);
}
