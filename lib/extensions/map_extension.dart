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

  /// From `some.difference(other)` will preffer taking values from some
  /// If `compareValues` set to `false` difference will calculate only by keys
  Map<T, Z> difference(
    Map<T, Z> other, {
    bool Function(Z previuos, Z next)? compare,
    bool compareValues = true,
    bool takeNullValues = true,
  }) {
    bool isNullable<U>() => null is U;
    final nullable = isNullable<Z>();
    const equality = FlexibleEquality();
    final current = this;
    final Map<T, Z> diff = {};

    if (compareValues) {
      final allKeys = {...current.keys, ...other.keys};
      for (final key in allKeys) {
        final currentItem = current[key];
        final otherItem = other[key];

        final takePair = otherItem == null && currentItem == null
            ? false
            : otherItem == null || currentItem == null
                ? true
                : compare != null
                    ? !compare(otherItem, currentItem)
                    : equality.notEquals(otherItem, currentItem);

        if (takePair) {
          if (currentItem == null) {
            if (nullable && takeNullValues) {
              diff[key] = currentItem as Z;
            }
          } else {
            diff[key] = currentItem;
          }
        }
      }
    } else {
      final diffKeys = current.keys.toSet().difference(other.keys.toSet());
      for (final key in diffKeys) {
        final value = current[key];
        if (value == null) {
          if (nullable && takeNullValues) {
            diff[key] = value as Z;
          }
        } else {
          diff[key] = value;
        }
      }
    }

    return diff;
  }

  Map<T, Z> intersection(
    Map<T, Z> other, {
    bool Function(Z previuos, Z next)? compare,
    bool takeNullValues = true,
    bool compareValues = true,
  }) {
    final oldMap = this;
    final oldKeys = oldMap.keys.toSet();
    final otherKeys = other.keys.toSet();
    final intersectedKeys = oldKeys.intersection(otherKeys);
    final temp = <T, Z>{};

    bool isNullable<U>() => null is U;
    final nullable = isNullable<Z>();
    takeNullValues = nullable;
    final equality = FlexibleEquality();
    for (final key in intersectedKeys) {
      final otherValue = other[key];
      final oldValue = oldMap[key];
      final take = !compareValues
          ? true
          : otherValue == null && oldValue == null
              ? true
              : otherValue == null || oldValue == null
                  ? false
                  : compare != null
                      ? compare(otherValue, oldValue)
                      : equality.equals(otherValue, oldValue);
      if (!take) continue;
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

  /// Preffer taking other value by default, can override behaviour with `resolveValue`
  Map<T, Z> union(
    Map<T, Z> other, {
    bool takeNullValues = true,
    Z? Function(T key, Z? current, Z? other)? resolveValue,
  }) {
    final current = this;
    final currentKeys = current.keys.toSet();
    final otherKeys = other.keys.toSet();
    final unionKeys = currentKeys.union(otherKeys);
    bool isNullable<U>() => null is U;

    final nullable = isNullable<Z>();
    takeNullValues = nullable;
    final temp = <T, Z>{};

    for (final key in unionKeys) {
      final isCurrent = currentKeys.contains(key);
      final isOther = otherKeys.contains(key);
      final isBoth = isCurrent && isOther;
      final otherValue = other[key];
      final currentValue = current[key];

      Z? resolve() {
        if (isBoth) {
          return resolveValue?.call(key, currentValue, otherValue) ??
              otherValue;
        } else if (isOther) {
          return otherValue;
        } else {
          return currentValue;
        }
      }

      final resultValue = resolve();
      if (resultValue == null) {
        if (takeNullValues) {
          temp[key] = resultValue as Z;
        }
      } else {
        temp[key] = resultValue;
      }
    }

    return temp;
  }

  void removeNullableValues() {
    return removeWhere(
      (key, value) {
        return value == null;
      },
    );
  }
}
