import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:grpc/grpc.dart';
import 'package:trayce/network/repo/containers_repo.dart';

import '../common/bloc/agent_network_bridge.dart';
import 'command_sender.dart';
import 'gen/api.pbgrpc.dart';

class EventContainersObserved {
  final List<Container> containers;

  EventContainersObserved(this.containers);
}

class EventAgentStarted {
  final String version;

  EventAgentStarted(this.version);
}

class EventAgentVerified {
  final bool valid;

  EventAgentVerified(this.valid);
}

class TrayceAgentService extends TrayceAgentServiceBase implements CommandSender {
  final _flows = <Flow>[];
  final _containers = <Container>[];
  final _commandStreamControllers = <StreamController<Command>>[];
  final AgentNetworkBridge _agentNetworkBridge;
  final EventBus _eventBus;

  TrayceAgentService({
    required AgentNetworkBridge agentNetworkBridge,
    required EventBus eventBus,
  })  : _agentNetworkBridge = agentNetworkBridge,
        _eventBus = eventBus {
    // Listen for commands to send
    _agentNetworkBridge.stream.listen((state) {
      if (state is SendCommand) {
        sendCommandToAll(state.command);
      }
    });

    _eventBus.on<EventSendCommand>().listen((event) {
      sendCommandToAll(event.command);
    });
  }

  @override
  Future<Reply> sendFlowsObserved(ServiceCall call, Flows request) async {
    _agentNetworkBridge.flowsObserved(request.flows);
    return Reply(status: 'success');
  }

  @override
  Future<Reply> sendContainersObserved(ServiceCall call, Containers request) async {
    _eventBus.fire(EventContainersObserved(request.containers));

    return Reply(status: 'success');
  }

  @override
  Future<Reply> sendAgentVerified(ServiceCall call, AgentVerified request) async {
    print('Agent verified: ${request.valid}');
    _agentNetworkBridge.agentVerified(request.valid);
    _eventBus.fire(EventAgentVerified(request.valid));
    return Reply(status: 'success');
  }

  @override
  Stream<Command> openCommandStream(ServiceCall call, Stream<AgentStarted> request) async* {
    await for (final agentStarted in request) {
      print('Agent started with version ${agentStarted.version}');
      _agentNetworkBridge.agentStarted(agentStarted.version);
      _eventBus.fire(EventAgentStarted(agentStarted.version));
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
