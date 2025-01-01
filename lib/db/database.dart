import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Return a function that matches the onCreate callback signature: void Function(Database db, int version)
Function(Database db, int version) initSchema(String schema) {
  return (Database db, int version) {
    final batch = db.batch();

    final List<String> queries = schema
        .split(';')
        .map((q) => q.trim())
        .where((q) => q.isNotEmpty)
        .toList();

    for (final query in queries) {
      batch.execute(query);
    }

    return batch.commit();
  };
}
