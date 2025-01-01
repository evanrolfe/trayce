import 'dart:typed_data';

import 'package:uuid/uuid.dart';

class Flow {
  final int? id;
  final String uuid;
  final String sourceAddr;
  final String destAddr;
  final String l4Protocol;
  final String l7Protocol;
  final Uint8List requestRaw;
  final Uint8List? responseRaw;
  final DateTime createdAt;

  Flow({
    this.id,
    String? uuid,
    required this.sourceAddr,
    required this.destAddr,
    required this.l4Protocol,
    required this.l7Protocol,
    required this.requestRaw,
    this.responseRaw,
    required this.createdAt,
  }) : uuid = uuid ?? const Uuid().v4();

  // Create a Flow from a Map (database row)
  factory Flow.fromMap(Map<String, dynamic> map) {
    return Flow(
      id: map['id'] as int?,
      uuid: map['uuid'] as String,
      sourceAddr: map['source_addr'] as String,
      destAddr: map['dest_addr'] as String,
      l4Protocol: map['l4_protocol'] as String,
      l7Protocol: map['l7_protocol'] as String,
      requestRaw: map['request_raw'] as Uint8List,
      responseRaw: map['response_raw'] as Uint8List?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Convert a Flow to a Map (for database insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'source_addr': sourceAddr,
      'dest_addr': destAddr,
      'l4_protocol': l4Protocol,
      'l7_protocol': l7Protocol,
      'request_raw': requestRaw,
      'response_raw': responseRaw,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create a copy of Flow with some fields updated
  Flow copyWith({
    int? id,
    String? uuid,
    String? sourceAddr,
    String? destAddr,
    String? l4Protocol,
    String? l7Protocol,
    Uint8List? requestRaw,
    Uint8List? responseRaw,
    DateTime? createdAt,
  }) {
    return Flow(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      sourceAddr: sourceAddr ?? this.sourceAddr,
      destAddr: destAddr ?? this.destAddr,
      l4Protocol: l4Protocol ?? this.l4Protocol,
      l7Protocol: l7Protocol ?? this.l7Protocol,
      requestRaw: requestRaw ?? this.requestRaw,
      responseRaw: responseRaw ?? this.responseRaw,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
