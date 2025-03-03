import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ExecutableHelper {
  // Static variable to store the executable path once it's prepared
  static String? _preparedExecutablePath;
  static bool _isInitializing = false;
  static Future<void>? _initializationFuture;

  // Initialize the executable at app startup
  static Future<void> initialize() async {
    if (_preparedExecutablePath != null || _isInitializing) {
      return _initializationFuture;
    }

    _isInitializing = true;
    _initializationFuture = _prepareExecutableInternal().then((path) {
      _preparedExecutablePath = path;
      _isInitializing = false;
    });

    return _initializationFuture;
  }

  // Synchronous getter for the executable path
  // Will return null if not initialized
  static String? get executablePath => _preparedExecutablePath;

  // Check if the executable is ready
  static bool get isReady => _preparedExecutablePath != null;

  // Get the executable path synchronously, throws an exception if not ready
  static String getExecutablePath() {
    if (_preparedExecutablePath == null) {
      throw StateError(
          'Executable path not initialized. Call ExecutableHelper.initialize() first.');
    }
    return _preparedExecutablePath!;
  }

  // Extracts the executable from assets and makes it executable
  // Returns the path to the executable
  static Future<String> prepareExecutable() async {
    if (_preparedExecutablePath != null) {
      return _preparedExecutablePath!;
    }

    if (_isInitializing) {
      await _initializationFuture;
      return _preparedExecutablePath!;
    }

    return _prepareExecutableInternal();
  }

  // Internal implementation of prepare executable
  static Future<String> _prepareExecutableInternal() async {
    String executablePath;

    try {
      // Try to get the application documents directory
      final appDir = await getApplicationCacheDirectory();
      executablePath = path.join(appDir.path, 'grpc_parser');
    } catch (e) {
      // Fallback to current directory if getApplicationDocumentsDirectory fails, as it does in unit tests
      print(
          'Warning: getApplicationDocumentsDirectory failed, using current directory instead: $e');
      executablePath =
          path.join(Directory.current.path, 'grpc_parser/grpc_parser');
    }

    final executableFile = File(executablePath);

    // Check if the executable already exists
    if (!await executableFile.exists()) {
      // Load the executable from assets
      final ByteData data = await rootBundle.load('grpc_parser/grpc_parser');
      final List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      // Write the executable to the file system
      await executableFile.writeAsBytes(bytes);
    }

    return executablePath;
  }
}
