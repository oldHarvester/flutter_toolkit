// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class SelectableState<Key, Value> with EquatableMixin {
  const SelectableState({
    required this.includedKeys,
    required this.excludedKeys,
    required this.includedMap,
    required this.excludedMap,
    required this.overrideAll,
    required this.totalCount,
    required this.keyReader,
  });

  final Set<Key> includedKeys;
  final Set<Key> excludedKeys;
  final Map<Key, Value> includedMap;
  final Map<Key, Value> excludedMap;
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
    Map<Key, Value>? includedMap,
    Map<Key, Value>? excludedMap,
    bool? overrideAll,
    int? totalCount,
    Key Function(Value value)? keyReader,
  }) {
    return SelectableState<Key, Value>(
      includedKeys: includedKeys ?? this.includedKeys,
      excludedKeys: excludedKeys ?? this.excludedKeys,
      includedMap: includedMap ?? this.includedMap,
      excludedMap: excludedMap ?? this.excludedMap,
      overrideAll: overrideAll ?? this.overrideAll,
      totalCount: totalCount ?? this.totalCount,
      keyReader: keyReader ?? this.keyReader,
    );
  }

  bool get isEmpty {
    return selectedCount == 0;
  }

  bool get isNotEmpty {
    return !isEmpty;
  }

  Iterable<Value> get includedValues => includedMap.values;

  Iterable<Value> get excludedValues => excludedMap.values;

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

  SelectableState<Key, Value> _changesWrapper(
    SelectableState<Key, Value> state,
  ) {
    return state;
  }

  SelectableState<Key, Value> toggleAll() {
    if (allSelected) {
      return unselectAll();
    } else {
      return selectAll();
    }
  }

  SelectableState<Key, Value> toggle(Value value) {
    if (isValueSelected(value)) {
      return unselect(value);
    } else {
      return select(value);
    }
  }

  SelectableState<Key, Value> select(Value value) {
    final key = keyReader(value);
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
    return _changesWrapper(
      copyWith(
        includedKeys: includedKeys,
        includedMap: includedMap,
        excludedKeys: excludedKeys,
        excludedMap: excludedMap,
      ),
    );
  }

  SelectableState<Key, Value> unselect(Value value) {
    final key = keyReader(value);
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
    return _changesWrapper(
      copyWith(
        excludedKeys: excludedKeys,
        excludedMap: excludedMap,
        includedKeys: includedKeys,
        includedMap: includedMap,
      ),
    );
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
    return _changesWrapper(copyWith(totalCount: totalCount));
  }
}
