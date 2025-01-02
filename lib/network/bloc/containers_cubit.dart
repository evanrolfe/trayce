import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../agent/command_sender.dart';
import '../../agent/container_observer.dart';
import '../../agent/gen/api.pb.dart';

// States
abstract class ContainersState {}

class ContainersInitial extends ContainersState {}

class ContainersLoaded extends ContainersState {
  final List<Container> containers;

  ContainersLoaded(this.containers);
}

class AgentRunning extends ContainersState {
  final bool running;

  AgentRunning(this.running);
}

class ContainersCubit extends Cubit<ContainersState> implements ContainerObserver {
  final CommandSender _commandSender;
  bool _agentRunning = false;
  DateTime? _lastHeartbeatAt;
  Timer? _heartbeatCheckTimer;

  ContainersCubit({required CommandSender commandSender})
      : _commandSender = commandSender,
        super(ContainersInitial()) {
    // Start heartbeat check timer
    _heartbeatCheckTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _checkHeartbeat(),
    );
  }

  @override
  Future<void> close() {
    _heartbeatCheckTimer?.cancel();
    return super.close();
  }

  void _checkHeartbeat() {
    if (_lastHeartbeatAt != null &&
        _agentRunning &&
        DateTime.now().difference(_lastHeartbeatAt!) > const Duration(seconds: 1)) {
      _agentRunning = false;
      print('Agent heartbeat check NOT RUNNING');
      emit(AgentRunning(false));
    }
  }

  final Set<String> _interceptedContainerIds = {};

  Set<String> get interceptedContainerIds => _interceptedContainerIds;
  bool get agentRunning => _agentRunning;
  DateTime? get lastHeartbeatAt => _lastHeartbeatAt;

  @override
  void containersUpdated(List<Container> containers) {
    _lastHeartbeatAt = DateTime.now();
    if (!_agentRunning) {
      _agentRunning = true;
      emit(AgentRunning(true));
    }
    emit(ContainersLoaded(containers));
  }

  void agentStopped() {
    _agentRunning = false;
    emit(AgentRunning(false));
  }

  void interceptContainers(List<String> containerIds) {
    print('Intercepting containers: $containerIds');
    _interceptedContainerIds.clear();
    _interceptedContainerIds.addAll(containerIds);

    // Create and send command
    final command = Command(
      type: 'set_settings',
      settings: Settings(containerIds: containerIds.toList()),
    );
    _commandSender.sendCommandToAll(command);
  }
}
