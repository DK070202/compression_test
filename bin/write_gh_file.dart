import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) async {
  // Read original JSON data from file
  String data = await File('indexed_file.txt').readAsString();

  // Original data encoded to bytes
  List<int> original = utf8.encode(data);

  // Compress data using gzip
  List<int> compressed = gzip.encode(original);

  // Write compressed data to file
  await File('indexed.gz').writeAsBytes(compressed);

  // Decompress the data to verify
  List<int> decompressed = gzip.decode(compressed);

  print('Original ${original.length} bytes');
  print('Compressed ${compressed.length} bytes');
  print('Decompressed ${decompressed.length} bytes');

  // Decode decompressed bytes back to string
  String decoded = utf8.decode(decompressed);

  // Assert to check if decompression matches original
  assert(data == decoded);
}
