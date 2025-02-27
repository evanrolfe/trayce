import 'package:flutter_test/flutter_test.dart';
import 'package:trayce/agent/gen/api.pb.dart' as pb;
import 'package:trayce/common/bloc/agent_network_bridge.dart' as bridge;
import 'package:trayce/network/bloc/containers_cubit.dart';

void main() {
  group('ContainersCubit', () {
    late bridge.AgentNetworkBridge agentNetworkBridge;
    late ContainersCubit cubit;

    setUp(() {
      agentNetworkBridge = bridge.AgentNetworkBridge();
      cubit = ContainersCubit(agentNetworkBridge: agentNetworkBridge);
    });

    tearDown(() {
      cubit.close();
    });

    group('receiving ContainersLoaded from the bridge', () {
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

        agentNetworkBridge.containersUpdated(containers);

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

    group('heartbeat timeout', () {
      test('it emits AgentRunning(false) after 200ms of no updates', () async {
        // Send empty containers list to trigger heartbeat
        cubit.containersUpdated(bridge.ContainersLoaded([], '1.0.0'));

        // Wait for heartbeat timeout
        final states = cubit.stream.take(1).toList();
        await Future.delayed(const Duration(milliseconds: 200));
        final emittedStates = await states;

        expect(emittedStates[0], isA<AgentRunning>().having((state) => state.running, 'running', false));
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

    group('interceptContainers()', () {
      test('it emits SendCommand with the container IDs', () async {
        final containerIds = ['abc123', 'def456'];

        // Listen to the bridge stream
        final bridgeState = agentNetworkBridge.stream.first;

        cubit.interceptContainers(containerIds);

        final state = await bridgeState;
        expect(
          state,
          isA<bridge.SendCommand>()
              .having((s) => s.command.type, 'command type', 'set_settings')
              .having((s) => s.command.settings.containerIds, 'container IDs', containerIds),
        );
      });
    });
  });
}
