import 'package:equatable/equatable.dart';
import 'package:flutter_toolkit/extensions/string_extension.dart';

enum ContentDispositionType {
  inline,
  attachment,
  formData;

  static ContentDispositionType fromString(String value) {
    switch (value.toLowerCase().trim()) {
      case 'inline':
        return inline;
      case 'attachment':
        return attachment;
      case 'form-data':
        return formData;
      default:
        throw UnimplementedError('$value - unknown disposition');
    }
  }

  static ContentDispositionType? tryFromString(String value) {
    try {
      return fromString(value);
    } catch (e) {
      return null;
    }
  }

  String toHeaderString() {
    switch (this) {
      case inline:
        return 'inline';
      case attachment:
        return 'attachment';
      case formData:
        return 'form-data';
    }
  }
}

class ContentDisposition with EquatableMixin {
  final ContentDispositionType type;
  final String? filename;
  final String? name;

  const ContentDisposition({
    required this.type,
    this.filename,
    this.name,
  });

  static ContentDisposition? tryParse(String header) {
    try {
      return ContentDisposition.parse(header);
    } catch (e) {
      return null;
    }
  }

  factory ContentDisposition.parse(String header) {
    final parts = header.split(';').map((e) => e.trim()).toList();

    final type = ContentDispositionType.tryFromString(parts.first);
    if (type == null) {
      throw FormatException('Unknown Content-Disposition type: ${parts.first}');
    }

    String? filename;
    String? name;

    for (final part in parts.skip(1)) {
      final eq = part.indexOf('=');
      if (eq == -1) continue;

      final key = part.substring(0, eq).trim().toLowerCase();
      final value = part.substring(eq + 1).trim().unquote();

      switch (key) {
        case 'filename*':
          filename = _decodeRfc5987(value);
        case 'filename':
          filename ??= value;
        case 'name':
          name = value;
      }
    }

    return ContentDisposition(
      type: type,
      filename: filename,
      name: name,
    );
  }

  static String _decodeRfc5987(String value) {
    final parts = value.split("''");
    if (parts.length < 2) return value;
    try {
      return Uri.decodeFull(parts.last);
    } catch (_) {
      return parts.last;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer(type.toHeaderString());

    if (name != null) {
      buffer.write('; name="$name"');
    }

    if (filename != null) {
      final needsEncoding = filename!.runes.any((r) => r > 127);
      if (needsEncoding) {
        final encoded = Uri.encodeFull(filename!);
        buffer.write("; filename*=UTF-8''$encoded");
      } else {
        buffer.write('; filename="$filename"');
      }
    }

    return buffer.toString();
  }

  @override
  List<Object?> get props => [type, filename, name];
}

// void main() {
//   final examples = [
//     'inline',
//     'attachment',
//     'attachment; filename="report.pdf"',
//     'attachment; filename="отчёт.pdf"',
//     "attachment; filename*=UTF-8''%D0%BE%D1%82%D1%87%D1%91%D1%82.pdf",
//     "attachment; filename=\"fallback.pdf\"; filename*=UTF-8''%D0%BE%D1%82%D1%87%D1%91%D1%82.pdf",
//     'form-data; name="username"',
//     'form-data; name="avatar"; filename="photo.jpg"',
//     "form-data; name=\"document\"; filename*=UTF-8''%D0%B4%D0%BE%D0%BA%D1%83%D0%BC%D0%B5%D0%BD%D1%82.pdf",
//   ];

//   for (final string in examples) {
//     final disposition = ContentDisposition.tryParse(string);
//     print(disposition.toString());
//   }
// }
