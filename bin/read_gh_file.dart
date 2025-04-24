import 'dart:convert';
import 'dart:io';

Future<void> readGzipFile(String path) async {
  final file = File(path);

  if (!await file.exists()) {
    print('File not found: $path');
    return;
  }

  final bytes = await file.readAsBytes();
  final decompressed = GZipCodec().decode(bytes);

  // If it's a text file inside, convert bytes to String
  final content = utf8.decode(decompressed);
  print('Decompressed content:\n$content');
}

void main() async {
  await readGzipFile('data_compressed.gz');
}