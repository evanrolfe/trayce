import 'package:flutter_bloc/flutter_bloc.dart';

import '../../agent/gen/api.pb.dart';

// States
abstract class AgentNetwork {}

class AgentNetworkInitial extends AgentNetwork {}

class ContainersLoaded extends AgentNetwork {
  final List<Container> containers;
  final String? version;

  ContainersLoaded(this.containers, this.version);
}

class SendCommand extends AgentNetwork {
  final Command command;

  SendCommand(this.command);
}

class FlowsObserved extends AgentNetwork {
  final List<Flow> flows;

  FlowsObserved(this.flows);
}

class AgentVerifiedState extends AgentNetwork {
  final bool valid;

  AgentVerifiedState(this.valid);
}

class AgentNetworkBridge extends Cubit<AgentNetwork> {
  String? version;

  AgentNetworkBridge() : super(AgentNetworkInitial());

  void containersUpdated(List<Container> containers) {
    emit(ContainersLoaded(containers, version));
  }

  void flowsObserved(List<Flow> flows) {
    emit(FlowsObserved(flows));
  }

  void sendCommandToAll(Command command) {
    emit(SendCommand(command));
  }

  void agentStarted(String version) {
    this.version = version;
  }

  void agentVerified(bool valid) {
    emit(AgentVerifiedState(valid));
  }
}
