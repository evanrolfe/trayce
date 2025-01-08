import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/proto_def.dart';
import '../repo/proto_def_repo.dart';

abstract class ProtoDefState {}

class ProtoDefInitial extends ProtoDefState {}

class ProtoDefLoading extends ProtoDefState {}

class ProtoDefLoaded extends ProtoDefState {
  final List<ProtoDef> protoDefs;

  ProtoDefLoaded(this.protoDefs);
}

class ProtoDefError extends ProtoDefState {
  final String message;

  ProtoDefError(this.message);
}

class ProtoDefCubit extends Cubit<ProtoDefState> {
  final ProtoDefRepo _repo;

  ProtoDefCubit(this._repo) : super(ProtoDefInitial());

  Future<void> loadProtoDefs() async {
    emit(ProtoDefLoading());
    try {
      final protoDefs = await _repo.getAll();
      emit(ProtoDefLoaded(protoDefs));
    } catch (e) {
      emit(ProtoDefError(e.toString()));
    }
  }
}
