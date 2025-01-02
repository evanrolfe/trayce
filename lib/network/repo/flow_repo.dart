import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/flow.dart';

class FlowRepo {
  final Database db;

  FlowRepo({required this.db});

  Future<Flow> save(Flow flow) async {
    final id = await db.insert(
      'flows',
      flow.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return flow.copyWith(id: id);
  }

  Future<List<Flow>> getAllFlows() async {
    final List<Map<String, dynamic>> maps = await db.query('flows');
    return maps.map((map) => Flow.fromMap(map)).toList();
  }
}
