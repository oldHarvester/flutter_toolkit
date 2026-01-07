import 'dart:convert';
import 'dart:typed_data';

extension StringExtension on String {
  bool get hasContent =>
      isNotEmpty && trim().isNotEmpty && replaceAll(' ', '').isNotEmpty;

  Uint8List? get tryBase64Decode {
    try {
      return base64Decode(this);
    } catch (e) {
      return null;
    }
  }
}
