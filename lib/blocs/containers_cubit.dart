import 'package:flutter_bloc/flutter_bloc.dart';

import '../agent/gen/api.pb.dart';

// States
abstract class ContainersState {}

class ContainersInitial extends ContainersState {}

class ContainersLoaded extends ContainersState {
  final List<Container> containers;

  ContainersLoaded(this.containers);
}

class ContainersCubit extends Cubit<ContainersState> {
  ContainersCubit() : super(ContainersInitial());

  void containersUpdated(List<Container> containers) {
    emit(ContainersLoaded(containers));
  }
}
