import 'dart:async';

import 'package:grpc/grpc.dart';

import 'gen/api.pbgrpc.dart';

class TrayceAgentService extends TrayceAgentServiceBase {
  final _flows = <Flow>[];
  final _containers = <Container>[];
  final _commandStreamControllers = <StreamController<Command>>[];

  @override
  Future<Reply> sendFlowsObserved(ServiceCall call, Flows request) async {
    _flows.addAll(request.flows);
    return Reply()..status = 'ok';
  }

  @override
  Future<Reply> sendContainersObserved(
      ServiceCall call, Containers request) async {
    print('Containers observed');
    _containers.clear();
    _containers.addAll(request.containers);
    return Reply()..status = 'ok';
  }

  @override
  Future<Reply> sendAgentStarted(ServiceCall call, AgentStarted request) async {
    print('Agent started');
    return Reply()..status = 'ok';
  }

  @override
  Stream<Command> openCommandStream(
      ServiceCall call, Stream<NooP> request) async* {
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

  void sendCommandToAll(Command command) {
    for (var controller in _commandStreamControllers) {
      controller.add(command);
    }
  }
}

class GrpcServer {
  Server? _server;

  Future<void> start() async {
    final service = TrayceAgentService();
    _server = await Server.create(services: [service]);
    _server?.serve(address: "0.0.0.0", port: 50051);
    print('Server listening on port 50051');
  }

  Future<void> stop() async {
    await _server?.shutdown();
  }
}
