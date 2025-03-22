import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:trayce/app.dart';
import 'package:trayce/common/bloc/agent_network_bridge.dart';
import 'package:trayce/common/database.dart';
import 'package:trayce/network/repo/proto_def_repo.dart';
import 'package:trayce/utils/grpc_parser_lib.dart';
import 'package:window_manager/window_manager.dart';

import 'agent/server.dart';
import 'network/bloc/containers_cubit.dart';
import 'network/bloc/flow_table_cubit.dart';
import 'network/repo/flow_repo.dart';

const String appVersion = '1.0.0';

void main(List<String> args) async {
  // Check for --version flag
  if (args.contains('--version')) {
    stdout.writeln('trayce v$appVersion');
    exit(0);
  }

  WidgetsFlutterBinding.ensureInitialized();

  await GrpcParserLib.ensureExists();

  // Set default window size
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    size: Size(1200, 800),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Connect DB and create repos
  final db = await connectDB();
  final flowRepo = FlowRepo(db: db);
  final protoDefRepo = ProtoDefRepo(db: db);

  // Create bridge cubits
  final agentNetworkBridge = AgentNetworkBridge();

  // Create Business logic cubits & services
  // Agent
  final grpcService = TrayceAgentService(agentNetworkBridge: agentNetworkBridge);
  // Network
  final containersCubit = ContainersCubit(agentNetworkBridge: agentNetworkBridge);
  final flowTableCubit = FlowTableCubit(agentNetworkBridge: agentNetworkBridge, flowRepo: flowRepo);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FlowRepo>(create: (context) => flowRepo),
        RepositoryProvider<ProtoDefRepo>(create: (context) => protoDefRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ContainersCubit>(create: (context) => containersCubit),
          BlocProvider<FlowTableCubit>(create: (context) => flowTableCubit),
        ],
        child: const App(appVersion: appVersion),
      ),
    ),
  );

  // Start the gRPC server
  final server = Server.create(services: [grpcService]);
  await server.serve(address: InternetAddress.anyIPv4, port: 50051, shared: true);
  print('Server listening on port 50051');
}
