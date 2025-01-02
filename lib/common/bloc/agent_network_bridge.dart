import 'package:flutter_bloc/flutter_bloc.dart';

import '../../agent/container_observer.dart';
import '../../agent/gen/api.pb.dart';

// States
abstract class AgentNetwork {}

class AgentNetworkInitial extends AgentNetwork {}

class ContainersLoaded extends AgentNetwork {
  final List<Container> containers;

  ContainersLoaded(this.containers);
}

class AgentRunning extends AgentNetwork {
  final bool running;

  AgentRunning(this.running);
}

class SendCommand extends AgentNetwork {
  final Command command;

  SendCommand(this.command);
}

class AgentNetworkBridge extends Cubit<AgentNetwork> implements ContainerObserver {
  AgentNetworkBridge() : super(AgentNetworkInitial());

  @override
  void containersUpdated(List<Container> containers) {
    emit(ContainersLoaded(containers));
  }

  void sendCommandToAll(Command command) {
    emit(SendCommand(command));
  }
}
