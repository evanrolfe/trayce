import 'package:flutter_bloc/flutter_bloc.dart';

import '../agent/command_sender.dart';
import '../agent/gen/api.pb.dart';

// States
abstract class ContainersState {}

class ContainersInitial extends ContainersState {}

class ContainersLoaded extends ContainersState {
  final List<Container> containers;

  ContainersLoaded(this.containers);
}

class ContainersCubit extends Cubit<ContainersState> {
  final CommandSender _commandSender;

  ContainersCubit({required CommandSender commandSender})
      : _commandSender = commandSender,
        super(ContainersInitial());

  final Set<String> _interceptedContainerIds = {};

  Set<String> get interceptedContainerIds => _interceptedContainerIds;

  void containersUpdated(List<Container> containers) {
    emit(ContainersLoaded(containers));
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
