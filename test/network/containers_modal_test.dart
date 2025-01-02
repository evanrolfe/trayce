import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/agent/command_sender.dart';
import 'package:ftrayce/agent/gen/api.pb.dart' as pb;
import 'package:ftrayce/network/bloc/containers_cubit.dart';
import 'package:ftrayce/network/widgets/containers_modal.dart';

class MockCommandSender implements CommandSender {
  @override
  void sendCommandToAll(pb.Command command) {}
}

void main() {
  late ContainersCubit containersCubit;

  setUp(() {
    containersCubit = ContainersCubit(commandSender: MockCommandSender());
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUpAll(() {
    final view = TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first;
    view.physicalSize = const Size(1024, 768);
    view.devicePixelRatio = 1.0;
  });

  tearDownAll(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  tearDown(() {
    containersCubit.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ContainersCubit>.value(
        value: containersCubit,
        child: const ContainersModal(),
      ),
    );
  }

  group('ContainersModal', () {
    testWidgets('shows containers list when loaded', (tester) async {
      // Arrange
      final containers = [
        pb.Container(id: 'a2db0b', name: 'hello', ip: "127.0.0.1", image: 'image1', status: 'running'),
        pb.Container(id: 'a3db0b', name: 'world', ip: "127.0.0.2", image: 'image1', status: 'running'),
      ];

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      containersCubit.containersUpdated(containers);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('hello'), findsOneWidget);
      expect(find.text('world'), findsOneWidget);
    });
  });
}
