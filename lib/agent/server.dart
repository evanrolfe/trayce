import 'dart:async';

import 'package:grpc/grpc.dart';

import 'command_sender.dart';
import 'container_observer.dart';
import 'gen/api.pbgrpc.dart';

class TrayceAgentService extends TrayceAgentServiceBase implements CommandSender {
  final _flows = <Flow>[];
  final _containers = <Container>[];
  final _commandStreamControllers = <StreamController<Command>>[];
  ContainerObserver? _containerObserver;

  TrayceAgentService();

  set containerObserver(ContainerObserver observer) {
    _containerObserver = observer;
  }

  @override
  Future<Reply> sendFlowsObserved(ServiceCall call, Flows request) async {
    _flows.addAll(request.flows);
    return Reply()..status = 'ok';
  }

  @override
  Future<Reply> sendContainersObserved(ServiceCall call, Containers request) async {
    print('Containers observed');
    _containers.clear();
    _containers.addAll(request.containers);

    _containerObserver?.containersUpdated(_containers);

    return Reply()..status = 'ok';
  }

  @override
  Future<Reply> sendAgentStarted(ServiceCall call, AgentStarted request) async {
    print('Agent started');
    return Reply()..status = 'ok';
  }

  @override
  Stream<Command> openCommandStream(ServiceCall call, Stream<NooP> request) async* {
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

  @override
  void sendCommandToAll(Command command) {
    for (var controller in _commandStreamControllers) {
      controller.add(command);
    }
  }
}
