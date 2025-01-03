import 'dart:convert';
import 'dart:typed_data';

import '../../agent/gen/api.pb.dart' as pb;
import 'flow_response.dart';

/// gRPC response with parsed fields
class GrpcResponse extends FlowResponse {
  final Map<String, List<String>> headers;
  final Uint8List body;

  const GrpcResponse({
    required this.headers,
    required this.body,
  }) : super();

  /// Creates a GrpcResponse from raw JSON bytes
  static GrpcResponse fromJson(Uint8List bytes) {
    final values = json.decode(utf8.decode(bytes)) as Map<String, dynamic>;
    return GrpcResponse(
      headers: (values['headers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as List).cast<String>()),
      ),
      body: Uint8List.fromList(base64.decode(values['payload'] as String)),
    );
  }

  /// Creates a GrpcResponse from a protobuf GRPCResponse
  factory GrpcResponse.fromProto(pb.GRPCResponse res) {
    // Convert headers from protobuf repeated fields to Map<String, List<String>>
    final headers = <String, List<String>>{};
    for (var entry in res.headers.entries) {
      headers[entry.key] = entry.value.values.map((v) => v.toString()).toList();
    }

    return GrpcResponse(
      headers: headers,
      body: Uint8List.fromList(res.payload),
    );
  }

  @override
  Uint8List toJson() {
    final map = {
      'headers': headers,
      'payload': base64.encode(body),
    };
    return utf8.encode(json.encode(map));
  }
}
