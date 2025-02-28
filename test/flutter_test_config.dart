import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:trayce/utils/executable_helper.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await ExecutableHelper.initialize();
  });

  // tearDown(() {
  //   print('Shared tearDown');
  // });

  await testMain();
}
