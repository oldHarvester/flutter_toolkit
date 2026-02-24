import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toolkit/extensions/uint8list_extension.dart';

@immutable
sealed class FileFormat with EquatableMixin {
  const FileFormat(this.format);

  bool get isRasterImage {
    return rasterImages.contains(this);
  }

  bool get isUnknown {
    return this is _UnknownFileExtension;
  }

  bool get isVectorImage {
    return vectorImages.contains(this);
  }

  bool get isImage {
    return isRasterImage || isVectorImage;
  }

  factory FileFormat.fromBytes(Uint8List bytes) {
    return bytes.fileFormat;
  }

  factory FileFormat.fromFilename(String filename) {
    try {
      final lastDotIndex = filename.lastIndexOf('.');

      if (lastDotIndex == -1 || lastDotIndex == filename.length - 1) {
        throw Exception(
          'File extension not found. Last index found: $lastDotIndex',
        );
      }

      final extensionStr = filename.substring(lastDotIndex + 1);
      return FileFormat.fromString(extensionStr);
    } catch (e) {
      return FileFormat.emptyUnknown();
    }
  }

  factory FileFormat.fromString(String string) {
    for (final ext in FileFormat.values) {
      if (ext.format == string) {
        return ext;
      }
    }
    return FileFormat.unknown(string);
  }

  factory FileFormat.fromBase64(String base64) {
    final bytes = base64Decode(base64);
    return FileFormat.fromBytes(bytes);
  }

  static FileFormat? tryFromBytes(Uint8List bytes) {
    try {
      return FileFormat.fromBytes(bytes);
    } catch (e) {
      return null;
    }
  }

  static FileFormat? tryFromBase64(String base64) {
    try {
      return FileFormat.fromBase64(base64);
    } catch (e) {
      return null;
    }
  }

  static FileFormat? tryFromFilename(String filename) {
    final format = FileFormat.fromFilename(filename);
    return format.isUnknown ? null : format;
  }

  static FileFormat? tryFromString(String string) {
    final format = FileFormat.fromString(string);
    return format.isUnknown ? null : format;
  }

  const factory FileFormat.emptyUnknown() = _EmptyUnknownFileExtension;

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

  static final Set<FileFormat> values = {
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
  };

  static final Set<FileFormat> images = {
    ...rasterImages,
    ...vectorImages,
  };

  static final Set<FileFormat> rasterImages = {png, jpg, jpeg, webP, bmp};

  static final Set<FileFormat> vectorImages = {svg};

  final String format;

  String get dotFormat {
    return '.$format';
  }
}

class _UnknownFileExtension extends FileFormat {
  const _UnknownFileExtension(super.format);
}

class _EmptyUnknownFileExtension extends _UnknownFileExtension {
  const _EmptyUnknownFileExtension() : super('');
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
