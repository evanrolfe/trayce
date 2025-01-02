import 'dart:typed_data';

import 'package:ftrayce/network/models/flow_response.dart';
import 'package:uuid/uuid.dart';

import '../../agent/gen/api.pb.dart' as pb;
import 'flow_request.dart';

class Flow {
  final int? id;
  final String uuid;
  final String sourceAddr;
  final String destAddr;
  final String l4Protocol;
  final String l7Protocol;
  final FlowRequest? request;
  final FlowResponse? response;
  final Uint8List requestRaw;
  final Uint8List responseRaw;
  final DateTime createdAt;

  Flow({
    this.id,
    String? uuid,
    required this.sourceAddr,
    required this.destAddr,
    required this.l4Protocol,
    required this.l7Protocol,
    required this.requestRaw,
    required this.responseRaw,
    required this.createdAt,
    this.request,
    this.response,
  }) : uuid = uuid ?? const Uuid().v4();

  // Create a Flow from an agent Flow protobuf message
  factory Flow.fromProto(pb.Flow agentFlow) {
    FlowRequest? request;
    Uint8List requestRaw = Uint8List(0);

    FlowResponse? response;
    Uint8List responseRaw = Uint8List(0);

    // Parse HTTP request if present
    if (agentFlow.hasHttpRequest()) {
      request = HttpRequest.fromProto(agentFlow.httpRequest);
      requestRaw = request.toJson();
    }

    // Parse HTTP response if present
    if (agentFlow.hasHttpResponse()) {
      response = HttpResponse.fromProto(agentFlow.httpResponse);
      responseRaw = response.toJson();
    }

    return Flow(
      uuid: agentFlow.uuid,
      sourceAddr: agentFlow.sourceAddr,
      destAddr: agentFlow.destAddr,
      l4Protocol: agentFlow.l4Protocol,
      l7Protocol: agentFlow.l7Protocol,
      request: request,
      response: response,
      requestRaw: requestRaw,
      responseRaw: responseRaw,
      createdAt: DateTime.now(),
    );
  }

  // Create a Flow from a Map (database row)
  factory Flow.fromMap(Map<String, dynamic> map) {
    final l7Protocol = map['l7_protocol'] as String;
    final requestRaw = map['request_raw'] as Uint8List;
    final responseRaw = map['response_raw'] as Uint8List;

    // Parse HTTP requests
    FlowRequest? request;
    if (l7Protocol == 'http' && requestRaw.isNotEmpty) {
      try {
        request = HttpRequest.fromJson(requestRaw);
      } catch (e) {
        print('Failed to parse HTTP request: $e');
      }
    }

    // Parse HTTP response
    FlowResponse? response;
    if (l7Protocol == 'http' && responseRaw.isNotEmpty) {
      try {
        response = HttpResponse.fromJson(responseRaw);
      } catch (e) {
        print('Failed to parse HTTP response: $e');
      }
    }

    return Flow(
      id: map['id'] as int?,
      uuid: map['uuid'] as String,
      sourceAddr: map['source_addr'] as String,
      destAddr: map['dest_addr'] as String,
      l4Protocol: map['l4_protocol'] as String,
      l7Protocol: l7Protocol,
      requestRaw: requestRaw,
      responseRaw: responseRaw,
      request: request,
      response: response,
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
    FlowRequest? request,
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
      request: request ?? this.request,
    );
  }
}
