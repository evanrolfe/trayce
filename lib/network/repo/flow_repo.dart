import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/flow.dart';

class FlowRepo {
  Database db;

  FlowRepo({required this.db});

  Future<Flow> save(Flow flow) async {
    // First check if flow exists
    final existing = await db.query(
      'flows',
      where: 'uuid = ?',
      whereArgs: [flow.uuid],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      // Update existing flow
      await db.update(
        'flows',
        {
          'response_raw': flow.responseRaw,
          'status': flow.status,
        },
        where: 'uuid = ?',
        whereArgs: [flow.uuid],
      );
      return flow.copyWith(id: existing.first['id'] as int);
    }

    // Insert new flow
    final id = await db.insert('flows', {
      'uuid': flow.uuid,
      'source': flow.source,
      'dest': flow.dest,
      'l4_protocol': flow.l4Protocol,
      'protocol': flow.l7Protocol,
      'operation': flow.operation,
      'status': flow.status,
      'request_raw': flow.requestRaw,
      'response_raw': flow.responseRaw,
      'created_at': flow.createdAt.toIso8601String(),
    });

    return flow.copyWith(id: id);
  }

  Future<List<Flow>> getAllFlows() async {
    final List<Map<String, dynamic>> maps = await db.query(
      'flows',
      orderBy: 'id DESC',
    );
    return maps.map((map) => Flow.fromMap(map)).toList();
  }
}
