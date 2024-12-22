import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';

import 'agent/server.dart';

Future<void> start() async {
  final service = TrayceAgentService();
  final server = Server.create(services: [service]);
  await server.serve(address: InternetAddress.anyIPv4, port: 50051, shared: true);
  print('Server listening on port 50051');
}

void main() async {
  print('Starting server...');
  await start();
}
