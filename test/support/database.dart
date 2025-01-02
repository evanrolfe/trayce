import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ftrayce/db/database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TestDatabase {
  static TestDatabase? _instance;
  late Database _db;

  // Private constructor
  TestDatabase._();

  // Getter for the database instance
  Database get db => _db;

  // Static method to get the singleton instance
  static Future<TestDatabase> get instance async {
    // Create instance if it doesn't exist
    _instance ??= TestDatabase._();

    try {
      _instance!._db;
    } catch (_) {
      await _instance!._initialize();
    }

    return _instance!;
  }

  // Initialize the database connection
  Future<void> _initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Connect DB
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final String schema = await rootBundle.loadString('schema.sql');

    // this stores the file in .dart_tool/sqflite_common_ffi/databases/
    _db = await databaseFactory.openDatabase('test.db',
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: initSchema(schema),
        ));

    print('Database initialized!!!!!');
  }

  // Method to close the database
  Future<void> close() async {
    await _db.close();
  }

  // truncate all tables
  Future<void> truncate() async {
    await _db.delete('flows');
    await _db.delete('proto_defs');
  }
}
