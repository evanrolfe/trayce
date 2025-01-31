import 'package:flutter_bloc/flutter_bloc.dart';

import '../../agent/gen/api.pb.dart' as pb;
import '../../common/bloc/agent_network_bridge.dart' as bridge;
import '../models/flow.dart';
import '../repo/flow_repo.dart';

// States
abstract class FlowTableState {}

class FlowTableInitial extends FlowTableState {}

class DisplayFlows extends FlowTableState {
  final List<Flow> flows;

  DisplayFlows(this.flows);
}

class FlowTableCubit extends Cubit<FlowTableState> {
  final FlowRepo _flowRepo;
  final bridge.AgentNetworkBridge _agentNetworkBridge;

  FlowTableCubit({
    required FlowRepo flowRepo,
    required bridge.AgentNetworkBridge agentNetworkBridge,
  })  : _flowRepo = flowRepo,
        _agentNetworkBridge = agentNetworkBridge,
        super(FlowTableInitial()) {
    // Listen to AgentNetworkBridge state changes
    _agentNetworkBridge.stream.listen((state) {
      if (state is bridge.FlowsObserved) {
        print('Received ${state.flows.length} flows');
        saveFlows(state.flows);
      }
    });
  }

  Future<void> saveFlows(List<pb.Flow> agentFlows) async {
    for (final agentFlow in agentFlows) {
      final flow = Flow.fromProto(agentFlow);
      await _flowRepo.save(flow);
    }
    reloadFlows();
  }

  Future<void> reloadFlows() async {
    final flows = await _flowRepo.getFlows();
    emit(DisplayFlows(flows));
  }
}

// String bytesToHexString(List<int> bytes) {
//   return bytes.map((byte) => '0x${byte.toRadixString(16).padLeft(2, '0')}').join(', ');
// }
