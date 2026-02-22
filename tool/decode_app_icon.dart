import 'dart:convert';
import 'dart:io';

/// Decodes the base64 payload in `assets/images/app_icon.base64.txt`
/// and writes `assets/images/app_icon.png`.
/// Run: `dart run tool/decode_app_icon.dart`

Future<void> main() async {
  final src = File('assets/images/app_icon.base64.txt');
  if (!await src.exists()) {
    print('Base64 source not found: ${src.path}');
    return;
  }
  final b64 = await src.readAsString();
  final bytes = base64Decode(b64.trim());
  final out = File('assets/images/app_icon.png');
  await out.create(recursive: true);
  await out.writeAsBytes(bytes);
  print('Wrote ${out.path} (${bytes.length} bytes)');
}
