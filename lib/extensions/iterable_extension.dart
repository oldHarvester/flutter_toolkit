import 'package:equatable/equatable.dart';
import 'package:flutter_toolkit/utils/flexible_equality.dart';

class IterableDifference<T> with EquatableMixin {
  const IterableDifference({
    required this.indexedAdded,
    required this.indexedEdited,
    required this.indexedRemoved,
  });

  final Map<int, T> indexedAdded;
  final Map<int, T> indexedRemoved;
  final Map<int, T> indexedEdited;

  Iterable<T> get added => indexedAdded.values;

  Iterable<T> get removed => indexedRemoved.values;

  Iterable<T> get edited => indexedEdited.values;

  @override
  String toString() {
    return '\n$runtimeType\nadded: $indexedAdded\nremoved: $indexedRemoved\nedited: $indexedEdited';
  }

  @override
  List<Object?> get props => [
        FlexibleEquality().hash(indexedAdded),
        FlexibleEquality().hash(indexedRemoved),
        FlexibleEquality().hash(indexedEdited),
      ];
}

extension IterableExtension<T> on Iterable<T> {
  T? itemAtOrNull(int index) {
    try {
      return elementAt(index);
    } catch (e) {
      return null;
    }
  }

  bool notContains(T item) {
    return !contains(item);
  }

  int? get lastIndexOrNull {
    try {
      return lastIndex;
    } catch (e) {
      return null;
    }
  }

  int? get firstIndexOrNull {
    try {
      return firstIndex;
    } catch (e) {
      return null;
    }
  }

  int get lastIndex {
    assert(!isEmpty, 'List is empty');
    return length - 1;
  }

  int get firstIndex {
    assert(!isEmpty, 'List is empty');
    return 0;
  }

  bool isIndexLast(int index) => index == lastIndex;

  bool isIndexFirst(int index) => index == firstIndex;

  bool exceedMax(int index) => index > lastIndex;

  bool exceedMin(int index) => index < firstIndex;

  T? nextFrom(int index) {
    return elementAtOrNull(index + 1);
  }

  T? previousFrom(int index) {
    if (index <= 0) return null;
    return elementAtOrNull(index - 1);
  }

  Iterable<T> paginate(int page, int limit) {
    final startIndex = page * limit;
    return skip(startIndex).take(limit);
  }

  IterableDifference<T> calculateDifference<Key>(
    Iterable<T> other, {
    required Key Function(T value) resolveKey,
    bool Function(T a, T b)? compare,
  }) {
    final oldList = toList();
    final newList = other.toList();
    final equals = compare ?? (T a, T b) => a == b;

    // key -> (index, value) для быстрого поиска
    final oldMap = <Key, (int index, T value)>{};
    for (var i = 0; i < oldList.length; i++) {
      oldMap[resolveKey(oldList[i])] = (i, oldList[i]);
    }

    final newMap = <Key, (int index, T value)>{};
    for (var i = 0; i < newList.length; i++) {
      newMap[resolveKey(newList[i])] = (i, newList[i]);
    }

    final added = <int, T>{};
    final removed = <int, T>{};
    final edited = <int, T>{};

    // Проход по new: если ключ отсутствует в old — added,
    // если присутствует но compare false — edited
    for (final entry in newMap.entries) {
      final oldEntry = oldMap[entry.key];
      if (oldEntry == null) {
        added[entry.value.$1] = entry.value.$2;
      } else if (!equals(oldEntry.$2, entry.value.$2)) {
        edited[entry.value.$1] = entry.value.$2;
      }
    }

    // Проход по old: если ключ отсутствует в new — removed
    for (final entry in oldMap.entries) {
      if (!newMap.containsKey(entry.key)) {
        removed[entry.value.$1] = entry.value.$2;
      }
    }

    return IterableDifference<T>(
      indexedAdded: added,
      indexedRemoved: removed,
      indexedEdited: edited,
    );
  }

  Map<Key, T> toMap<Key>({
    required Key Function(T value) resolveKey,
  }) {
    return Map.fromEntries(
      map(
        (value) {
          return MapEntry(
            resolveKey(value),
            value,
          );
        },
      ),
    );
  }

  Map<int, T> toIndexedMap() {
    final keys = Iterable.generate(
      length,
      (index) => index,
    );
    return Map.fromEntries(
      keys.map(
        (index) {
          return MapEntry(
            index,
            elementAt(index),
          );
        },
      ),
    );
  }
}
