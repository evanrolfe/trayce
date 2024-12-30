import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/agent/gen/api.pb.dart' as pb;
import 'package:ftrayce/agent/gen/api.pbgrpc.dart';
import 'package:ftrayce/main.dart' as app;
import 'package:grpc/grpc.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Create screenshots directory
    final screenshotsDir = Directory('screenshots');
    if (!screenshotsDir.existsSync()) {
      screenshotsDir.createSync();
    }
  });

  group('ContainersModal Integration Tests', () {
    testWidgets('containers modal when no containers have been observed, then some are observed', (tester) async {
      // Start the real app once for all tests
      app.main();
      await tester.pumpAndSettle();

      // Find and click the Network tab
      final networkTab = find.byIcon(Icons.format_list_numbered);
      await tester.tap(networkTab);
      await tester.pumpAndSettle();

      // Find and click the Containers button
      final containersButton = find.text('Containers');
      await tester.tap(containersButton);
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('screenshots/containers_modal_01.png'),
      );

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
    });
  });
}
