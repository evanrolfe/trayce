import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/agent/command_sender.dart';
import 'package:ftrayce/agent/gen/api.pb.dart' as pb;
import 'package:ftrayce/network/bloc/containers_cubit.dart';

class MockCommandSender implements CommandSender {
  @override
  void sendCommandToAll(pb.Command command) {}
}

void main() {
  group('ContainersCubit', () {
    late ContainersCubit cubit;
    late MockCommandSender commandSender;

    setUp(() {
      commandSender = MockCommandSender();
      cubit = ContainersCubit(commandSender: commandSender);
    });

    tearDown(() {
      cubit.close();
    });

    group('containersUpdated()', () {
      test('it emits AgentRunning(true) and ContainersLoaded with the containers', () async {
        final containers = [
          pb.Container(
            id: 'abc123',
            name: 'test-container',
            image: 'nginx:latest',
            ip: '172.17.0.2',
            status: 'running',
          ),
        ];

        // Start listening to the stream before emitting
        final states = cubit.stream.take(2).toList();

        cubit.containersUpdated(containers);

        final emittedStates = await states;
        expect(emittedStates[0], isA<AgentRunning>().having((state) => state.running, 'running', true));
        expect(
            emittedStates[1],
            isA<ContainersLoaded>().having(
              (state) => state.containers,
              'containers',
              containers,
            ));
      });
    });

    group('agentStopped()', () {
      test('it emits AgentRunning(false)', () async {
        // Start listening to the stream before emitting
        final future = cubit.stream.first;

        cubit.agentStopped();

        final state = await future;
        expect(state, isA<AgentRunning>().having((state) => state.running, 'running', false));
      });
    });
  });
}
