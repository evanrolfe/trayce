import 'dart:convert';
import 'dart:typed_data';

import '../../agent/gen/api.pb.dart' as pb;
import 'flow_request.dart';

/// gRPC request with parsed fields
class GrpcRequest extends FlowRequest {
  final String path;
  final Map<String, List<String>> headers;
  final Uint8List body;

  const GrpcRequest({
    required this.path,
    required this.headers,
    required this.body,
  }) : super();

  /// Creates a GrpcRequest from raw JSON bytes
  static GrpcRequest fromJson(Uint8List bytes) {
    final values = json.decode(utf8.decode(bytes)) as Map<String, dynamic>;
    return GrpcRequest(
      path: values['path'] as String,
      headers: (values['headers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as List).cast<String>()),
      ),
      body: Uint8List.fromList(base64.decode(values['payload'] as String)),
    );
  }

  /// Creates a GrpcRequest from a protobuf GRPCRequest
  factory GrpcRequest.fromProto(pb.GRPCRequest req) {
    // Convert headers from protobuf repeated fields to Map<String, List<String>>
    final headers = <String, List<String>>{};
    for (var entry in req.headers.entries) {
      headers[entry.key] = entry.value.values.map((v) => v.toString()).toList();
    }

    return GrpcRequest(
      path: req.path,
      headers: headers,
      body: Uint8List.fromList(req.payload),
    );
  }

  @override
  Uint8List toJson() {
    final map = {
      'path': path,
      'headers': headers,
      'payload': base64.encode(body),
    };
    return utf8.encode(json.encode(map));
  }
}
