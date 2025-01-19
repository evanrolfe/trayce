import 'dart:async';

import 'package:grpc/grpc.dart';

import '../common/bloc/agent_network_bridge.dart';
import 'command_sender.dart';
import 'gen/api.pbgrpc.dart';

class TrayceAgentService extends TrayceAgentServiceBase implements CommandSender {
  final _flows = <Flow>[];
  final _containers = <Container>[];
  final _commandStreamControllers = <StreamController<Command>>[];
  final AgentNetworkBridge _agentNetworkBridge;

  TrayceAgentService({
    required AgentNetworkBridge agentNetworkBridge,
  }) : _agentNetworkBridge = agentNetworkBridge {
    // Listen for commands to send
    _agentNetworkBridge.stream.listen((state) {
      if (state is SendCommand) {
        sendCommandToAll(state.command);
      }
    });
  }

  @override
  Future<Reply> sendFlowsObserved(ServiceCall call, Flows request) async {
    _agentNetworkBridge.flowsObserved(request.flows);
    return Reply(status: 'success');
  }

  @override
  Future<Reply> sendContainersObserved(ServiceCall call, Containers request) async {
    _containers.clear();
    _containers.addAll(request.containers);

    // _containerObserver?.containersUpdated(_containers);
    _agentNetworkBridge.containersUpdated(_containers);

    return Reply(status: 'success');
  }

  @override
  Future<Reply> sendAgentStarted(ServiceCall call, AgentStarted request) async {
    print('Agent started');
    return Reply(status: 'success');
  }

  @override
  Stream<Command> openCommandStream(ServiceCall call, Stream<AgentStarted> request) async* {
    await for (final agentStarted in request) {
      print('Agent started with version ${agentStarted.version}');
      _agentNetworkBridge.agentStarted(agentStarted.version);

      final controller = StreamController<Command>();
      _commandStreamControllers.add(controller);

      try {
        await for (final command in controller.stream) {
          yield command;
        }
      } finally {
        _commandStreamControllers.remove(controller);
        await controller.close();
      }
    }
  }

  @override
  void sendCommandToAll(Command command) {
    for (var controller in _commandStreamControllers) {
      controller.add(command);
    }
  }
}
