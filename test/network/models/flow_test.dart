import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ftrayce/network/models/flow.dart';
import 'package:ftrayce/network/models/http_request.dart';
import 'package:ftrayce/network/models/http_response.dart';

import '../../support/flow_factory.dart';

void main() {
  group('Flow', () {
    final testTime = DateTime.parse('2024-01-01T12:00:00Z');

    group('toMap()', () {
      test('it converts to map correctly', () {
        final flow = buildHttpReqFlow(id: 1, uuid: 'test-uuid');

        final map = flow.toMap();

        expect(map['id'], 1);
        expect(map['uuid'], 'test-uuid');
        expect(map['source_addr'], '192.168.0.1');
        expect(map['dest_addr'], '192.168.0.2');
        expect(map['l4_protocol'], 'tcp');
        expect(map['l7_protocol'], 'http');
        expect((map['request_raw'] as Uint8List).length, 96);
        expect((map['response_raw'] as Uint8List).length, 0);
        expect(map['created_at'], testTime.toIso8601String());
      });
    });

    group('fromMap()', () {
      test('it creates from map correctly', () {
        final request =
            HttpRequest(method: 'GET', host: '172.17.0.3', path: '/', httpVersion: 'HTTP/1.1', headers: {}, body: '');
        final response =
            HttpResponse(httpVersion: 'HTTP/1.1', status: 200, statusMsg: 'OK', headers: {}, body: 'Hello World!');
        final map = {
          'id': 1,
          'uuid': 'test-uuid',
          'source_addr': '192.168.0.1',
          'dest_addr': '192.168.0.2',
          'l4_protocol': 'tcp',
          'l7_protocol': 'http',
          'request_raw': request.toJson(),
          'response_raw': response.toJson(),
          'created_at': testTime.toIso8601String(),
        };

        final flow = Flow.fromMap(map);
        final flowReq = flow.request as HttpRequest;
        final flowResp = flow.response as HttpResponse;
        expect(flow.id, 1);
        expect(flow.uuid, 'test-uuid');
        expect(flow.sourceAddr, '192.168.0.1');
        expect(flow.destAddr, '192.168.0.2');
        expect(flow.l4Protocol, 'tcp');
        expect(flow.l7Protocol, 'http');
        expect(flow.requestRaw.length, 96);
        expect(flow.responseRaw.length, 93);

        expect(flowReq.path, '/');
        expect(flowReq.method, 'GET');
        expect(flowReq.host, '172.17.0.3');
        expect(flowReq.httpVersion, 'HTTP/1.1');
        expect(flowReq.headers, {});
        expect(flowReq.body, '');

        expect(flowResp.httpVersion, 'HTTP/1.1');
        expect(flowResp.status, 200);
        expect(flowResp.statusMsg, 'OK');
        expect(flowResp.headers, {});
        expect(flowResp.body, 'Hello World!');

        expect(flow.createdAt, testTime);
      });
    });

    group('copyWith()', () {
      test('it copies only specified fields', () {
        final original = buildHttpReqFlow(id: 1, uuid: 'test-uuid');

        final newTime = DateTime.parse('2024-01-02T12:00:00Z');
        final newBytes = Uint8List.fromList([5, 6, 7, 8]);

        final copied = original.copyWith(
          sourceAddr: '192.168.1.2',
          responseRaw: newBytes,
          createdAt: newTime,
        );

        // Changed fields
        expect(copied.sourceAddr, '192.168.1.2');
        expect(copied.responseRaw, newBytes);
        expect(copied.createdAt, newTime);

        // Unchanged fields
        expect(copied.id, original.id);
        expect(copied.uuid, original.uuid);
        expect(copied.destAddr, original.destAddr);
        expect(copied.l4Protocol, original.l4Protocol);
        expect(copied.l7Protocol, original.l7Protocol);
        expect(copied.requestRaw, original.requestRaw);
      });
    });
  });
}
