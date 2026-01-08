import 'dart:convert';
import 'dart:typed_data';

enum TruncateDirection {
  start, // Обрезка с начала
  end, // Обрезка с конца
}

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

  bool get isWebUrl {
    final str = this;
    try {
      final uri = Uri.parse(str);
      return (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  String truncateString({
    int maxLength = 20,
    String ellipsis = '...',
    TruncateDirection direction = TruncateDirection.start,
  }) {
    final text = this;
    // Проверка на валидность входных данных
    if (maxLength <= 0) {
      return '';
    }

    // Если строка короче или равна максимальной длине, возвращаем как есть
    if (text.length <= maxLength) {
      return text;
    }

    // Если многоточие длиннее чем максимальная длина, просто обрезаем строку
    if (ellipsis.length >= maxLength) {
      return direction == TruncateDirection.end
          ? text.substring(0, maxLength)
          : text.substring(text.length - maxLength);
    }

    // Обрезаем строку с учетом многоточия и направления
    if (direction == TruncateDirection.end) {
      // Обрезка с конца (по умолчанию)
      return text.substring(0, maxLength - ellipsis.length) + ellipsis;
    } else {
      // Обрезка с начала
      return ellipsis +
          text.substring(text.length - (maxLength - ellipsis.length));
    }
  }

  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
