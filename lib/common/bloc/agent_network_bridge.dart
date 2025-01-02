import 'package:flutter_bloc/flutter_bloc.dart';

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

class FlowsObserved extends AgentNetwork {
  final List<Flow> flows;

  FlowsObserved(this.flows);
}

class AgentNetworkBridge extends Cubit<AgentNetwork> {
  AgentNetworkBridge() : super(AgentNetworkInitial());

  void containersUpdated(List<Container> containers) {
    emit(ContainersLoaded(containers));
  }

  void flowsObserved(List<Flow> flows) {
    emit(FlowsObserved(flows));
  }

  void sendCommandToAll(Command command) {
    emit(SendCommand(command));
  }
}
