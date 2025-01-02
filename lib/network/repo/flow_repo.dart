import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/flow.dart';

class FlowRepo {
  final Database db;

  FlowRepo({required this.db});

  Future<Flow> save(Flow flow) async {
    final id = await db.rawInsert('''
      INSERT INTO flows (uuid, source_addr, dest_addr, l4_protocol, l7_protocol, request_raw, response_raw, created_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(uuid) DO UPDATE SET response_raw = excluded.response_raw;
    ''', [
      flow.uuid,
      flow.sourceAddr,
      flow.destAddr,
      flow.l4Protocol,
      flow.l7Protocol,
      flow.requestRaw,
      flow.responseRaw,
      flow.createdAt.toIso8601String(),
    ]);

    return flow.copyWith(id: id);
  }

  Future<List<Flow>> getAllFlows() async {
    final List<Map<String, dynamic>> maps = await db.query('flows');
    return maps.map((map) => Flow.fromMap(map)).toList();
  }
}
