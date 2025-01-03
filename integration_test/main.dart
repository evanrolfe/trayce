import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/main.dart' as app;
import 'package:integration_test/integration_test.dart';

import 'containers_modal_test.dart' as containers_modal_test;
import 'flow_table_test.dart' as flow_table_test;

// NOTE: This is how we have to run integration tests (as opposed to letting flutter test run multiple tests)
// because of this open issue: https://github.com/flutter/flutter/issues/135673

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration test', (tester) async {
    // Create screenshots directory
    final screenshotsDir = Directory('screenshots');
    if (!screenshotsDir.existsSync()) {
      screenshotsDir.createSync();
    }

    // Start the real app once for all tests
    app.main();
    // Add a longer initial pump and settle to ensure app is fully loaded
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await containers_modal_test.test(tester);
    await flow_table_test.test(tester);
  });
}
