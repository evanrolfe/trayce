import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ContainersModal Integration Tests', () {
    testWidgets('opens containers modal when containers button is clicked', (tester) async {
      // Create screenshots directory
      final screenshotsDir = Directory('screenshots');
      if (!screenshotsDir.existsSync()) {
        screenshotsDir.createSync();
      }

      // Start the real app
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
        matchesGoldenFile('integration_test/screenshots/containers_modal_01.png'),
      );

      // Verify the modal is shown
      expect(find.textContaining('Trayce Agent is not running!'), findsOneWidget);
      expect(find.textContaining('docker run'), findsOneWidget);
    });
  });
}
