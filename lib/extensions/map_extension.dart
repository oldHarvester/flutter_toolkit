import 'package:flutter_toolkit/utils/flexible_equality.dart';

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
    const equality = FlexibleEquality();
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

  Map<T, Z> intersection(Map<T, Z> other, {bool takeNullValues = true}) {
    final oldMap = this;
    final oldKeys = oldMap.keys.toSet();
    final otherKeys = other.keys.toSet();
    final intersectedKeys = oldKeys.intersection(otherKeys);
    final temp = <T, Z>{};

    bool isNullable<U>() => null is U;
    final nullable = isNullable<Z>();
    takeNullValues = nullable;

    for (final key in intersectedKeys) {
      final otherValue = other[key];
      final oldValue = oldMap[key];
      if (otherValue == null) {
        if (takeNullValues) {
          temp[key] = otherValue as Z;
        } else {
          if (oldValue == null) {
            if (takeNullValues) {
              temp[key] = oldValue as Z;
            }
          } else {
            temp[key] = oldValue;
          }
        }
      } else {
        temp[key] = otherValue;
      }
    }
    
    return temp;
  }

  Map<T, Z> union(
    Map<T, Z> other, {
    bool takeNullValues = true,
  }) {
    final oldMap = this;
    final oldKeys = oldMap.keys.toSet();
    final otherKeys = other.keys.toSet();
    final keys = oldKeys.union(otherKeys);
    bool isNullable<U>() => null is U;

    final nullable = isNullable<Z>();
    takeNullValues = nullable;
    final temp = <T, Z>{};

    for (final key in keys) {
      final otherValue = other[key];
      final oldValue = oldMap[key];
      if (otherValue == null) {
        if (takeNullValues) {
          temp[key] = otherValue as Z;
        } else {
          if (oldValue == null) {
            if (takeNullValues) {
              temp[key] = oldValue as Z;
            }
          } else {
            temp[key] = oldValue;
          }
        }
      } else {
        temp[key] = otherValue;
      }
    }

    return temp;
  }
}
