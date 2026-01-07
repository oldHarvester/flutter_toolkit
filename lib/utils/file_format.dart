import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toolkit/extensions/uint8list_extension.dart';

@immutable
sealed class FileFormat with EquatableMixin {
  const FileFormat(this.format);

  static FileFormat? tryFromBytes(Uint8List bytes) {
    return bytes.fileFormat;
  }

  factory FileFormat.fromFilename(String filename) {
    final lastDotIndex = filename.lastIndexOf('.');

    if (lastDotIndex == -1 || lastDotIndex == filename.length - 1) {
      throw Exception(
        'File extension not found. Last index found: $lastDotIndex',
      );
    }

    final extensionStr = filename.substring(lastDotIndex + 1);
    return FileFormat.fromString(extensionStr);
  }

  factory FileFormat.fromString(String string) {
    if (string.isEmpty) {
      throw Exception('File extension must not be empty');
    }
    for (final ext in FileFormat.values) {
      if (ext.format == string) {
        return ext;
      }
    }
    return FileFormat.unknown(string);
  }

  const factory FileFormat.unknown(String format) = _UnknownFileExtension;

  @override
  List<Object?> get props => [format];

  static const pdf = _PDFFileExtension();

  static const xlsx = _XLSXFileExtension();

  static const xls = _XLSFileExtension();

  static const jpg = _JPGFileExtension();

  static const jpeg = _JPEGFileExtension();

  static const png = _PNGFileExtension();

  static const svg = _SVGFileExtension();

  static const doc = _DOCFileExtension();

  static const docx = _DOCXFileExtension();

  static const webP = _WEBPFileExtension();

  static const bmp = _BMPFileExtension();

  static const gif = _GIFFileExtension();

  static const List<FileFormat> values = [
    pdf,
    xlsx,
    xls,
    jpg,
    jpeg,
    png,
    svg,
    doc,
    docx,
    webP,
    bmp,
    gif,
  ];

  static const List<FileFormat> images = [
    ...rasterImages,
    ...vectorImages,
  ];

  static const List<FileFormat> rasterImages = [png, jpg, jpeg, webP, bmp];

  static const List<FileFormat> vectorImages = [svg];

  static FileFormat? tryFromFilename(String filename) {
    try {
      return FileFormat.fromFilename(filename);
    } catch (e) {
      return null;
    }
  }

  static FileFormat? tryFromString(String string) {
    try {
      return FileFormat.fromString(string);
    } catch (e) {
      return null;
    }
  }

  final String format;

  String get dotFormat {
    return '.$format';
  }

  @override
  bool operator ==(covariant FileFormat other) {
    return other.format == format;
  }

  @override
  int get hashCode => Object.hashAll([format]);
}

class _UnknownFileExtension extends FileFormat {
  const _UnknownFileExtension(super.format);
}

class _PDFFileExtension extends FileFormat {
  const _PDFFileExtension() : super('pdf');
}

class _XLSXFileExtension extends FileFormat {
  const _XLSXFileExtension() : super('xlsx');
}

class _XLSFileExtension extends FileFormat {
  const _XLSFileExtension() : super('xls');
}

class _JPGFileExtension extends FileFormat {
  const _JPGFileExtension() : super('jpg');
}

class _PNGFileExtension extends FileFormat {
  const _PNGFileExtension() : super('png');
}

class _JPEGFileExtension extends FileFormat {
  const _JPEGFileExtension() : super('jpeg');
}

class _SVGFileExtension extends FileFormat {
  const _SVGFileExtension() : super('svg');
}

class _DOCFileExtension extends FileFormat {
  const _DOCFileExtension() : super('doc');
}

class _DOCXFileExtension extends FileFormat {
  const _DOCXFileExtension() : super('docx');
}

class _WEBPFileExtension extends FileFormat {
  const _WEBPFileExtension() : super('webp');
}

class _BMPFileExtension extends FileFormat {
  const _BMPFileExtension() : super('bmp');
}

class _GIFFileExtension extends FileFormat {
  const _GIFFileExtension() : super('gif');
}
