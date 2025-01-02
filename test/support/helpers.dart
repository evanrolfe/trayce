import 'dart:typed_data';

/// Converts a hexdump string to Uint8List by extracting just the hex bytes
Uint8List hexToBytes(String hexdump) {
  // Extract just the hex bytes, ignoring offsets and ASCII representation
  final hexBytes = hexdump.split('\n').map((line) => line.split('  ')[1].split('|')[0].trim()).join(' ').split(' ');

  return Uint8List.fromList(
    hexBytes.map((hex) => int.parse(hex, radix: 16)).toList(),
  );
}
