import 'dart:io';
import 'dart:typed_data';

import 'package:trayce/utils/executable_helper.dart';

class ProtoDef {
  final int? id;
  final String name;
  final String filePath;
  final String protoFile;
  final DateTime createdAt;

  const ProtoDef({
    this.id,
    required this.name,
    required this.filePath,
    required this.protoFile,
    required this.createdAt,
  });

  /// Creates a ProtoDef from a map
  factory ProtoDef.fromMap(Map<String, dynamic> map) {
    return ProtoDef(
      id: map['id'] as int?,
      name: map['name'] as String,
      filePath: map['file_path'] as String,
      protoFile: map['proto_file'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Converts this ProtoDef to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'file_path': filePath,
      'proto_file': protoFile,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Creates a copy of this ProtoDef with the given fields replaced with the new values
  ProtoDef copyWith({
    int? id,
    String? name,
    String? filePath,
    String? protoFile,
    DateTime? createdAt,
  }) {
    return ProtoDef(
      id: id ?? this.id,
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
      protoFile: protoFile ?? this.protoFile,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String parseGRPCMessage(Uint8List msg, String grpcMsgPath, bool isResponse) {
    // Create a temporary file with the proto content
    final tempFile = File('${Directory.systemTemp.path}/trayce_protodef_${id ?? 'new'}.proto');
    tempFile.writeAsStringSync(protoFile);

    try {
      // Convert message bytes to hex string
      final hexMsg = msg.map((b) => '\\x${b.toRadixString(16).padLeft(2, '0')}').join('');
      final cmdArgs = ['-method', grpcMsgPath, '-proto', tempFile.path, '-message', hexMsg];

      if (isResponse) {
        cmdArgs.add('-response');
      }

      // Run grpc_parser
      // May want to look at calling the Go code directly from Dart using ffi:
      // https://dev.to/leehack/how-to-use-golang-in-flutter-application-golang-ffi-1950
      final gprcParserPath = ExecutableHelper.getExecutablePath();

      final result = Process.runSync(gprcParserPath, cmdArgs);

      if (result.exitCode != 0) {
        throw Exception('Failed to parse gRPC message: ${result.stderr}');
      }

      return result.stdout as String;
    } finally {
      // Clean up the temporary file
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }
    }
  }
}
