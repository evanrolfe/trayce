import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Return a function that matches the onCreate callback signature: void Function(Database db, int version)
Function(Database db, int version) initSchema(String schema) {
  return (Database db, int version) {
    final batch = db.batch();

    final List<String> queries = schema.split(';').map((q) => q.trim()).where((q) => q.isNotEmpty).toList();

    for (final query in queries) {
      batch.execute(query);
    }

    return batch.commit();
  };
}

Future<Database> connectDB(AssetBundle rootBundle) async {
  // Load schema.sql file
  final String schema = await rootBundle.loadString('schema.sql');

  // Connect DB
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // see also: inMemoryDatabasePath
  // this stores the file in .dart_tool/sqflite_common_ffi/databases/
  var databasesPath = await getDatabasesPath();
  String dbPath = path.join(databasesPath, 'tmp.db');

  // Delete existing database file if it exists
  if (await databaseFactory.databaseExists(dbPath)) {
    await databaseFactory.deleteDatabase(dbPath);
  }

  var db = await databaseFactory.openDatabase(dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: initSchema(schema),
      ));
  return db;
}
