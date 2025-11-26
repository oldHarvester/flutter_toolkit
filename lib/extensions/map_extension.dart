extension MapExtension<T, Z> on Map<T, Z> {
  String toInfoString({
    String Function(T item)? keyFormatter,
    String Function(Z item)? valueFormatter,
  }) {
    final buffer = StringBuffer();
    for (final entry in entries) {
      buffer.write('\n');
      final key = entry.key;
      final keyStr = keyFormatter?.call(key) ?? key.toString();
      final value = entry.value;
      final valueStr = valueFormatter?.call(value) ?? value.toString();
      buffer.write('$keyStr: $valueStr');
    }
    return buffer.toString();
  }
}
