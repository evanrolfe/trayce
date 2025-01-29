import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftrayce/common/bloc/agent_network_bridge.dart';
import 'package:ftrayce/common/database.dart';
import 'package:ftrayce/menu_bar.dart';
import 'package:ftrayce/network/repo/proto_def_repo.dart';
import 'package:ftrayce/status_bar.dart';
import 'package:grpc/grpc.dart';

import 'agent/server.dart';
import 'editor/editor.dart';
import 'network/bloc/containers_cubit.dart';
import 'network/bloc/flow_table_cubit.dart';
import 'network/repo/flow_repo.dart';
import 'network/widgets/network.dart';

const Color backgroundColor = Color(0xFF1E1E1E);
const Color textColor = Color(0xFFD4D4D4);
const Color sidebarColor = Color(0xFF333333);
const String appVersion = '1.0.0';

class NoTransitionBuilder extends PageTransitionsBuilder {
  const NoTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

void main(List<String> args) async {
  // Check for --version flag
  if (args.contains('--version')) {
    stdout.writeln('trayce v$appVersion');
    exit(0);
  }

  WidgetsFlutterBinding.ensureInitialized();

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
        child: const MyApp(),
      ),
    ),
  );

  // Start the gRPC server
  final server = await Server.create(services: [grpcService]);
  await server.serve(address: InternetAddress.anyIPv4, port: 50051, shared: true);
  print('Server listening on port 50051');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _navigatorKey = GlobalKey<NavigatorState>();

  // Helper function to create AppScaffold instances
  static Widget _createPage(int index) {
    return AppScaffold(
      selectedIndex: index,
      child: index == 0 ? const Network() : const Editor(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trayce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(Colors.teal),
          thickness: WidgetStateProperty.all(8),
          radius: const Radius.circular(4),
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: sidebarColor,
          indicatorColor: Colors.teal,
          unselectedIconTheme: IconThemeData(color: textColor),
          selectedIconTheme: IconThemeData(color: textColor),
          unselectedLabelTextStyle: TextStyle(color: textColor),
          selectedLabelTextStyle: TextStyle(color: textColor),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.windows: NoTransitionBuilder(),
            TargetPlatform.linux: NoTransitionBuilder(),
            TargetPlatform.macOS: NoTransitionBuilder(),
          },
        ),
      ),
      home: Builder(
        builder: (context) => AppMenuBar(
          appVersion: appVersion,
          onFileOpen: (path) async {
            try {
              final flowRepo = context.read<FlowRepo>();
              final protoDefRepo = context.read<ProtoDefRepo>();
              final oldDb = flowRepo.db;
              if (oldDb.path == path) {
                return;
              }
              final newDb = await connectDB(path);
              flowRepo.db = newDb;
              protoDefRepo.db = newDb;
              await oldDb.close();

              // Navigate to network page using the navigator key
              if (context.mounted) {
                _navigatorKey.currentState?.pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => _createPage(0),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error opening database: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: Scaffold(
            body: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                Widget page;
                if (settings.name == '/editor') {
                  page = _createPage(1);
                } else {
                  page = _createPage(0);
                }
                return MaterialPageRoute(builder: (_) => page);
              },
            ),
            bottomNavigationBar: const StatusBar(),
          ),
        ),
      ),
    );
  }
}

class AppScaffold extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

  const AppScaffold({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  bool isHovering0 = false;
  bool isHovering1 = false;

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/network');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/editor');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            color: sidebarColor,
            child: Column(
              children: [
                Listener(
                  onPointerDown: (_) => _navigateToPage(0),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovering0 = true),
                    onExit: (_) => setState(() => isHovering0 = false),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: widget.selectedIndex == 0 ? const Color(0xFF4DB6AC) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        color: widget.selectedIndex == 0 || isHovering0 ? const Color(0xFF3A3A3A) : Colors.transparent,
                      ),
                      child: const Icon(
                        Icons.format_list_numbered,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                Listener(
                  onPointerDown: (_) => _navigateToPage(1),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovering1 = true),
                    onExit: (_) => setState(() => isHovering1 = false),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: widget.selectedIndex == 1 ? const Color(0xFF4DB6AC) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        color: widget.selectedIndex == 1 || isHovering1 ? const Color(0xFF3A3A3A) : Colors.transparent,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: Color(0xFF474747),
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
