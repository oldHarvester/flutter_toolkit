import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class SelectableState<Key, Value extends Object> with EquatableMixin {
  const SelectableState._({
    this.includedKeys = const {},
    this.excludedKeys = const {},
    this.includedMap = const {},
    this.excludedMap = const {},
    this.overrideAll = false,
    this.totalCount = 0,
    required this.keyReader,
  });

  const SelectableState({
    required this.keyReader,
  })  : includedKeys = const {},
        excludedKeys = const {},
        excludedMap = const {},
        includedMap = const {},
        overrideAll = false,
        totalCount = 0;

  final Set<Key> includedKeys;
  final Set<Key> excludedKeys;
  final Map<Key, Value?> includedMap;
  final Map<Key, Value?> excludedMap;
  final bool overrideAll;
  final int totalCount;
  final Key Function(Value value) keyReader;

  @override
  List<Object?> get props => [
        DeepCollectionEquality().hash(includedKeys),
        DeepCollectionEquality().hash(excludedKeys),
        DeepCollectionEquality().hash(includedMap),
        DeepCollectionEquality().hash(excludedMap),
        overrideAll,
        totalCount,
        keyReader,
      ];

  SelectableState<Key, Value> copyWith({
    Set<Key>? includedKeys,
    Set<Key>? excludedKeys,
    Map<Key, Value?>? includedMap,
    Map<Key, Value?>? excludedMap,
    bool? overrideAll,
    int? totalCount,
    Key Function(Value value)? keyReader,
  }) {
    return changesWrapper(
      previous: this,
      next: SelectableState<Key, Value>._(
        includedKeys: includedKeys ?? this.includedKeys,
        excludedKeys: excludedKeys ?? this.excludedKeys,
        includedMap: includedMap ?? this.includedMap,
        excludedMap: excludedMap ?? this.excludedMap,
        overrideAll: overrideAll ?? this.overrideAll,
        totalCount: totalCount ?? this.totalCount,
        keyReader: keyReader ?? this.keyReader,
      ),
    );
  }

  bool get isEmpty {
    return selectedCount == 0;
  }

  bool get isNotEmpty {
    return !isEmpty;
  }

  List<Value> get includedValues {
    final temp = <Value>[];
    for (final item in includedMap.values) {
      if (item != null) {
        temp.add(item);
      }
    }
    return temp;
  }

  List<Value> get excludedValues {
    final temp = <Value>[];
    for (final item in excludedMap.values) {
      if (item != null) {
        temp.add(item);
      }
    }
    return temp;
  }

  bool get isSelecting {
    if (overrideAll) {
      return true;
    } else {
      return includedKeys.isNotEmpty;
    }
  }

  int get selectedCount =>
      overrideAll ? totalCount - excludedKeys.length : includedKeys.length;

  String displaySelected({String separator = ' / '}) {
    return [selectedCount, totalCount].join(separator);
  }

  bool get allSelected {
    if (overrideAll) {
      return excludedValues.isEmpty;
    } else {
      if (totalCount != 0) {
        return includedValues.length == totalCount;
      } else {
        return false;
      }
    }
  }

  Value? readIncludedValue(Key key) {
    return includedMap[key];
  }

  Value? readValue(Key key) {
    return readIncludedValue(key) ?? readExcludedValue(key);
  }

  Value? readExcludedValue(Key key) {
    return excludedMap[key];
  }

  SelectableState<Key, Value> selectEntries(
    Iterable<MapEntry<Key, Value?>> entries,
  ) {
    if (entries.isEmpty) {
      return this;
    } else {
      var temp = this;
      for (final entry in entries) {
        temp = temp.select(entry.key, entry.value);
      }
      return temp;
    }
  }

  SelectableState<Key, Value> selectKeys(Iterable<Key> keys) {
    return selectEntries(
      keys.map(
        (key) {
          return MapEntry(key, null);
        },
      ),
    );
  }

  SelectableState<Key, Value> unselectKeys(Iterable<Key> keys) {
    return unselectEntries(
      keys.map(
        (key) {
          return MapEntry(
            key,
            null,
          );
        },
      ),
    );
  }

  SelectableState<Key, Value> unselectEntries(
      Iterable<MapEntry<Key, Value?>> entries) {
    if (entries.isEmpty) {
      return this;
    } else {
      var temp = this;
      for (final entry in entries) {
        temp = temp.unselect(entry.key, entry.value);
      }
      return temp;
    }
  }

  SelectableState<Key, Value> selectValues(Iterable<Value> values) {
    return selectEntries(
      values.map(
        (value) {
          return MapEntry(
            keyReader(value),
            value,
          );
        },
      ),
    );
  }

  SelectableState<Key, Value> unselectValues(Iterable<Value> values) {
    return unselectEntries(
      values.map(
        (value) {
          return MapEntry(
            keyReader(value),
            value,
          );
        },
      ),
    );
  }

  SelectableState<Key, Value> selectAll() {
    return copyWith(
      overrideAll: true,
      excludedKeys: {},
      includedKeys: {},
      excludedMap: {},
      includedMap: {},
    );
  }

  SelectableState<Key, Value> unselectAll() {
    return copyWith(
      overrideAll: false,
      excludedKeys: {},
      includedKeys: {},
      excludedMap: {},
      includedMap: {},
    );
  }

  SelectableState<Key, Value> changesWrapper({
    required SelectableState<Key, Value> previous,
    required SelectableState<Key, Value> next,
  }) {
    return next;
  }

  SelectableState<Key, Value> toggleAll() {
    if (allSelected) {
      return unselectAll();
    } else {
      return selectAll();
    }
  }

  SelectableState<Key, Value> toggleValue(Value value) {
    if (isValueSelected(value)) {
      return unselectValue(value);
    } else {
      return selectValue(value);
    }
  }

  SelectableState<Key, Value> toggle(Key key, [Value? value]) {
    if (isKeySelected(key)) {
      return unselect(key, value);
    } else {
      return select(key, value);
    }
  }

  SelectableState<Key, Value> select(Key key, [Value? value]) {
    final includedKeys = {...this.includedKeys};
    final includedMap = {...this.includedMap};
    final excludedKeys = {...this.excludedKeys};
    final excludedMap = {...this.excludedMap};
    if (overrideAll) {
      if (excludedKeys.contains(key)) {
        excludedKeys.remove(key);
        excludedMap.remove(key);
      }
    } else {
      if (includedKeys.notContains(key)) {
        includedKeys.add(key);
        includedMap[key] = value;
      }
    }
    return copyWith(
      includedKeys: includedKeys,
      includedMap: includedMap,
      excludedKeys: excludedKeys,
      excludedMap: excludedMap,
    );
  }

  SelectableState<Key, Value> unselect(Key key, [Value? value]) {
    final includedKeys = {...this.includedKeys};
    final excludedKeys = {...this.excludedKeys};
    final includedMap = {...this.includedMap};
    final excludedMap = {...this.excludedMap};
    if (overrideAll) {
      if (excludedKeys.notContains(key)) {
        excludedKeys.add(key);
        excludedMap[key] = value;
      }
    } else {
      if (includedKeys.contains(key)) {
        includedKeys.remove(key);
        includedMap.remove(key);
      }
    }
    return copyWith(
      excludedKeys: excludedKeys,
      excludedMap: excludedMap,
      includedKeys: includedKeys,
      includedMap: includedMap,
    );
  }

  SelectableState<Key, Value> selectValue(Value value) {
    final key = keyReader(value);
    return select(key, value);
  }

  SelectableState<Key, Value> unselectValue(Value value) {
    final key = keyReader(value);
    return unselect(key, value);
  }

  bool isValueSelected(Value value) {
    final key = keyReader(value);
    return isKeySelected(key);
  }

  bool isKeySelected(Key key) {
    if (overrideAll) {
      return !excludedKeys.contains(key);
    } else {
      return includedKeys.contains(key);
    }
  }

  SelectableState<Key, Value> onTotalCountChanged(int totalCount) {
    return copyWith(totalCount: totalCount);
  }
}
