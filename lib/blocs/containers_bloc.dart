import 'package:flutter_bloc/flutter_bloc.dart';

import '../agent/gen/api.pbgrpc.dart';

// Events
abstract class ContainersEvent {}

class ContainersUpdated extends ContainersEvent {
  final List<Container> containers;

  ContainersUpdated(this.containers);
}

// States
abstract class ContainersState {}

class ContainersInitial extends ContainersState {}

class ContainersLoaded extends ContainersState {
  final List<Container> containers;

  ContainersLoaded(this.containers);
}

// Bloc
class ContainersBloc extends Bloc<ContainersEvent, ContainersState> {
  ContainersBloc() : super(ContainersInitial()) {
    on<ContainersUpdated>((event, emit) {
      emit(ContainersLoaded(event.containers));
    });
  }
}
