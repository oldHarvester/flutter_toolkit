import 'dart:typed_data';

import 'package:flutter_toolkit/utils/file_format.dart';

extension Uint8ListX on Uint8List {
  FileFormat? get fileFormat {
    if (_isPDF) return FileFormat.pdf;
    if (_isXLSX) return FileFormat.xlsx;
    if (_isXLS) return FileFormat.xls;
    if (_isJPEG) return FileFormat.jpeg;
    if (_isPNG) return FileFormat.png;
    if (_isSVG) return FileFormat.svg;
    if (_isDOCX) return FileFormat.docx;
    if (_isDOC) return FileFormat.doc;
    if (_isWebP) return FileFormat.webP;
    if (_isBMP) return FileFormat.bmp;
    if (_isGIF) return FileFormat.gif;
    return null;
  }

  bool get _isPDF {
    final bytes = this;
    if (bytes.length < 4) return false;
    return bytes[0] == 0x25 && // %
        bytes[1] == 0x50 && // P
        bytes[2] == 0x44 && // D
        bytes[3] == 0x46; // F
  }

  // XLSX: ZIP архив, содержащий xl/
  bool get _isXLSX {
    final bytes = this;
    if (bytes.length < 4) return false;

    // Проверяем ZIP signature
    bool isZip = bytes[0] == 0x50 &&
        bytes[1] == 0x4B &&
        bytes[2] == 0x03 &&
        bytes[3] == 0x04;

    if (!isZip) return false;

    // Дополнительная проверка: поиск "xl/" в содержимом (характерно для XLSX)
    if (bytes.length > 100) {
      String header = String.fromCharCodes(bytes.sublist(0, 200));
      return header.contains('xl/') || header.contains('workbook');
    }

    return isZip; // Базовая проверка ZIP
  }

  // XLS: Microsoft Office документ (старый формат)
  bool get _isXLS {
    final bytes = this;
    if (bytes.length < 8) return false;

    // OLE2 signature (используется в старых Office файлах)
    bool isOLE = bytes[0] == 0xD0 &&
        bytes[1] == 0xCF &&
        bytes[2] == 0x11 &&
        bytes[3] == 0xE0 &&
        bytes[4] == 0xA1 &&
        bytes[5] == 0xB1 &&
        bytes[6] == 0x1A &&
        bytes[7] == 0xE1;

    if (!isOLE) return false;

    // Дополнительная проверка для XLS
    if (bytes.length > 2000) {
      // Ищем характерные для Excel байты
      for (int i = 512; i < bytes.length - 20 && i < 2000; i++) {
        // Workbook signature в XLS файлах
        if (bytes[i] == 0x09 && bytes[i + 1] == 0x08) {
          return true;
        }
      }
    }

    return false; // Это OLE, но не уверены что XLS
  }

  // JPEG: FF D8 FF
  bool get _isJPEG {
    final bytes = this;
    if (bytes.length < 3) return false;
    return bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF;
  }

  // PNG: 89 50 4E 47 0D 0A 1A 0A
  bool get _isPNG {
    final bytes = this;
    if (bytes.length < 8) return false;
    return bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
  }

  // SVG: текстовый XML файл
  bool get _isSVG {
    final bytes = this;
    if (bytes.length < 5) return false;

    // SVG начинается с < или <?xml
    String start = String.fromCharCodes(
        bytes.sublist(0, bytes.length > 100 ? 100 : bytes.length));
    start = start.trim().toLowerCase();

    return start.startsWith('<svg') ||
        start.startsWith('<?xml') && start.contains('<svg');
  }

  // DOCX: ZIP архив, содержащий word/
  bool get _isDOCX {
    final bytes = this;
    if (bytes.length < 4) return false;

    // Проверяем ZIP signature
    bool isZip = bytes[0] == 0x50 &&
        bytes[1] == 0x4B &&
        bytes[2] == 0x03 &&
        bytes[3] == 0x04;

    if (!isZip) return false;

    // Дополнительная проверка: поиск "word/" в содержимом (характерно для DOCX)
    if (bytes.length > 100) {
      String header = String.fromCharCodes(bytes.sublist(0, 200));
      return header.contains('word/') || header.contains('document');
    }

    return false; // Это ZIP, но не уверены что DOCX
  }

  // DOC: Microsoft Office документ (старый формат)
  bool get _isDOC {
    final bytes = this;
    if (bytes.length < 8) return false;

    // OLE2 signature
    bool isOLE = bytes[0] == 0xD0 &&
        bytes[1] == 0xCF &&
        bytes[2] == 0x11 &&
        bytes[3] == 0xE0 &&
        bytes[4] == 0xA1 &&
        bytes[5] == 0xB1 &&
        bytes[6] == 0x1A &&
        bytes[7] == 0xE1;

    if (!isOLE) return false;

    // Дополнительная проверка для DOC
    if (bytes.length > 2000) {
      // Ищем характерные для Word байты
      for (int i = 512; i < bytes.length - 20 && i < 2000; i++) {
        // Word document signature
        if (bytes[i] == 0xEC && bytes[i + 1] == 0xA5) {
          return true;
        }
      }
    }

    return false; // Это OLE, но не уверены что DOC
  }

  // WebP: RIFF....WEBP
  bool get _isWebP {
    final bytes = this;
    if (bytes.length < 12) return false;

    // RIFF
    bool isRIFF = bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46;

    // WEBP
    bool isWEBP = bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50;

    return isRIFF && isWEBP;
  }

  // BMP: BM
  bool get _isBMP {
    final bytes = this;
    if (bytes.length < 2) return false;
    return bytes[0] == 0x42 && bytes[1] == 0x4D; // BM
  }

  // GIF: GIF87a или GIF89a
  bool get _isGIF {
    final bytes = this;
    if (bytes.length < 6) return false;

    // GIF8
    bool isGIF8 = bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x38;

    if (!isGIF8) return false;

    // 7a или 9a
    return (bytes[4] == 0x37 || bytes[4] == 0x39) && bytes[5] == 0x61;
  }
}
