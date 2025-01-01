import 'package:flutter_bloc/flutter_bloc.dart';

import '../db/flow.dart';
import '../db/flow_repo.dart';

// States
abstract class FlowTableState {}

class FlowTableInitial extends FlowTableState {}

class DisplayFlows extends FlowTableState {
  final List<Flow> flows;

  DisplayFlows(this.flows);
}

class FlowTableCubit extends Cubit<FlowTableState> {
  final FlowRepo _flowRepo;

  FlowTableCubit({required FlowRepo flowRepo})
      : _flowRepo = flowRepo,
        super(FlowTableInitial());

  Future<void> reloadFlows() async {
    final flows = await _flowRepo.getAllFlows();
    emit(DisplayFlows(flows));
  }
}
