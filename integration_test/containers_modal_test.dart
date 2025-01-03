import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/agent/gen/api.pb.dart' as pb;
import 'package:ftrayce/agent/gen/api.pbgrpc.dart';
import 'package:grpc/grpc.dart';

// https://github.com/flutter/flutter/issues/135673
Future<void> test(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Find and click the Network tab
  final networkTab = find.byIcon(Icons.format_list_numbered);
  expect(networkTab, findsOneWidget); // Add verification that icon exists
  await tester.tap(networkTab);
  await tester.pumpAndSettle();

  // Find and click the Containers button
  final containersButton = find.text('Containers');
  await tester.tap(containersButton);
  await tester.pumpAndSettle();
  // await expectLater(
  //   find.byType(MaterialApp),
  //   matchesGoldenFile('screenshots/containers_modal_01.png'),
  // );

  // Verify the modal is shown
  expect(find.textContaining('Trayce Agent is not running!'), findsOneWidget);
  expect(find.textContaining('docker run'), findsOneWidget);

  // Create the GRPC client
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(), // Use this for non-TLS connections
    ),
  );
  final client = TrayceAgentClient(channel);

  // Send containers observed
  final containers = [
    pb.Container(id: 'a2db0b', name: 'hello', ip: "127.0.0.1", image: 'image1', status: 'running'),
    pb.Container(id: 'a3db0b', name: 'world', ip: "127.0.0.2", image: 'image1', status: 'running'),
  ];
  try {
    final response = await client.sendContainersObserved(pb.Containers(containers: containers));
    print('Response received: $response');
  } catch (e) {
    print('Error: $e');
  }
  await tester.pumpAndSettle();

  // Verify the modal is shown
  expect(find.text('hello'), findsOneWidget);
  expect(find.text('world'), findsOneWidget);

  // Close the modal by tapping outside
  await tester.tapAt(const Offset(20, 20)); // Tap in top-left corner, outside modal
}
