import 'package:flutter_bloc/flutter_bloc.dart';

import '../agent/gen/api.pb.dart';
import '../agent/server.dart';

// States
abstract class ContainersState {}

class ContainersInitial extends ContainersState {}

class ContainersLoaded extends ContainersState {
  final List<Container> containers;

  ContainersLoaded(this.containers);
}

class ContainersCubit extends Cubit<ContainersState> {
  TrayceAgentService? _agentService;

  ContainersCubit() : super(ContainersInitial());

  set agentService(TrayceAgentService service) {
    _agentService = service;
  }

  final Set<String> _interceptedContainerIds = {};

  Set<String> get interceptedContainerIds => _interceptedContainerIds;

  void containersUpdated(List<Container> containers) {
    emit(ContainersLoaded(containers));
  }

  void interceptContainers(List<String> containerIds) {
    print('Intercepting containers: $containerIds');
    _interceptedContainerIds.clear();
    _interceptedContainerIds.addAll(containerIds);

    if (_agentService != null) {
      // Create and send command
      final command = Command(
        type: 'set_settings',
        settings: Settings(containerIds: containerIds.toList()),
      );
      _agentService!.sendCommandToAll(command);
    }
  }
}
