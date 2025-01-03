import 'dart:async';

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

  // Open command stream and receive the commands sent to it
  final agentStarted = pb.AgentStarted(version: '1.0.0');
  final controller = StreamController<pb.AgentStarted>();
  final commandStream = client.openCommandStream(controller.stream);
  final commandsReceived = <pb.Command>[];
  final subscription = commandStream.listen((command) {
    commandsReceived.add(command);
  });
  controller.add(agentStarted);

  // Send containers observed
  final containers = [
    pb.Container(id: 'a2db0b', name: 'hello', ip: "127.0.0.1", image: 'image1', status: 'running'),
    pb.Container(id: 'a3db0b', name: 'world', ip: "127.0.0.2", image: 'image1', status: 'running'),
  ];
  await client.sendContainersObserved(pb.Containers(containers: containers));
  await tester.pumpAndSettle();

  // Verify the modal is shown
  expect(find.text('hello'), findsOneWidget);
  expect(find.text('world'), findsOneWidget);

  // Find and click the checkbox for container a3db0b
  final containerRow = find.text('a3db0b');
  final checkbox = find
      .descendant(
        of: find.ancestor(
          of: containerRow,
          matching: find.byType(Row),
        ),
        matching: find.byType(Checkbox),
      )
      .first;
  await tester.tap(checkbox);
  await tester.pumpAndSettle();

  // Click save button
  expect(find.text('Save'), findsOneWidget);
  final saveButton = find.text('Save');
  await tester.tap(saveButton);
  await tester.pumpAndSettle();

  // Verify the command was sent to intercept the container selected
  expect(commandsReceived.length, 1);
  final cmd = commandsReceived[0];
  expect(cmd.type, 'set_settings');
  expect(cmd.settings.containerIds, ['a3db0b']);

  // Cleanup
  await subscription.cancel();
  await controller.close();
  await channel.shutdown();
}
