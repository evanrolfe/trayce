import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../agent/gen/api.pb.dart';
import '../../common/bloc/agent_network_bridge.dart' as bridge;

// States
abstract class ContainersState {}

class ContainersInitial extends ContainersState {}

class ContainersLoaded extends ContainersState {
  static const minVersion = '0.2.0';

  final List<Container> containers;
  final String? version;

  ContainersLoaded(this.containers, this.version);

  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  bool versionOk() {
    if (version == null) return false;

    try {
      final currentVersion = getExtendedVersionNumber(version!);
      final minimum = getExtendedVersionNumber(minVersion);
      return currentVersion >= minimum;
    } catch (e) {
      return false;
    }
  }
}

class AgentRunning extends ContainersState {
  final bool running;

  AgentRunning(this.running);
}

class AgentVerified extends ContainersState {
  final bool valid;

  AgentVerified(this.valid);
}

class ContainersCubit extends Cubit<ContainersState> {
  final bridge.AgentNetworkBridge _agentNetworkBridge;
  bool _agentRunning = false;
  DateTime? _lastHeartbeatAt;
  Timer? _heartbeatCheckTimer;
  final Settings _settings = Settings();
  static const _licenseKeyPref = 'license_key';
  bool _isVerified = false;

  ContainersCubit({
    required bridge.AgentNetworkBridge agentNetworkBridge,
  })  : _agentNetworkBridge = agentNetworkBridge,
        super(ContainersInitial()) {
    _initSettings();

    // Start heartbeat check timer
    _heartbeatCheckTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _checkHeartbeat(),
    );

    // Listen to AgentNetworkBridge state changes
    _agentNetworkBridge.stream.listen((state) {
      if (state is bridge.ContainersLoaded) {
        containersUpdated(state);
      } else if (state is bridge.AgentVerifiedState) {
        _isVerified = state.valid;
        emit(AgentVerified(state.valid));
      }
    });
  }

  Future<void> _initSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLicenseKey = prefs.getString(_licenseKeyPref);
    if (savedLicenseKey != null) {
      _settings.licenseKey = savedLicenseKey;
      _sendSettings();
    }
  }

  @override
  Future<void> close() {
    _heartbeatCheckTimer?.cancel();
    return super.close();
  }

  void _checkHeartbeat() {
    if (_lastHeartbeatAt != null &&
        _agentRunning &&
        DateTime.now().difference(_lastHeartbeatAt!) > const Duration(seconds: 2)) {
      _agentRunning = false;
      print('Agent heartbeat check NOT RUNNING');
      emit(AgentRunning(false));
    }
  }

  Set<String> get interceptedContainerIds => _settings.containerIds.toSet();
  bool get agentRunning => _agentRunning;
  DateTime? get lastHeartbeatAt => _lastHeartbeatAt;
  String? get licenseKey => _settings.licenseKey;
  bool get isVerified => _isVerified;

  void containersUpdated(bridge.ContainersLoaded state) {
    _lastHeartbeatAt = DateTime.now();
    if (!_agentRunning) {
      _agentRunning = true;
      _sendSettings();
      emit(AgentRunning(true));
    }
    emit(ContainersLoaded(state.containers, state.version));
  }

  void agentStopped() {
    _agentRunning = false;
    emit(AgentRunning(false));
  }

  void interceptContainers(List<String> containerIds) {
    print('Intercepting containers: $containerIds');
    _settings.containerIds.clear();
    _settings.containerIds.addAll(containerIds);
    _sendSettings();
  }

  Future<void> setLicenseKey(String licenseKey) async {
    print('Setting license key: $licenseKey');
    _settings.licenseKey = licenseKey;

    // Save to persistent storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_licenseKeyPref, licenseKey);

    _sendSettings();
  }

  void _sendSettings() {
    final command = Command(
      type: 'set_settings',
      settings: _settings,
    );
    _agentNetworkBridge.sendCommandToAll(command);
  }
}
