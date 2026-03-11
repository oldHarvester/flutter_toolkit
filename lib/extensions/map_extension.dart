import 'package:collection/collection.dart';

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

  Map<T, Z> difference(Map<T, Z> newMap) {
    const equality = DeepCollectionEquality();
    final oldMap = this;
    final Map<T, Z> diff = {};
    final allKeys = {...oldMap.keys, ...newMap.keys};
    bool isNullable<U>() => null is U;

    final nullable = isNullable<Z>();
    for (final key in allKeys) {
      if (!equality.equals(oldMap[key], newMap[key])) {
        final temp = newMap[key];
        if (temp == null && !nullable) {
          diff.remove(key);
        } else {
          diff[key] = temp as Z;
        }
      }
    }

    return diff;
  }
}
