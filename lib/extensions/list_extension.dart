import 'package:flutter_toolkit/extensions/iterable_extension.dart';

extension ListExtension<T> on List<T> {
  List<T> addSeparator(T separator) {
    final items = this;
    if (items.isEmpty) return [];

    final result = <T>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(separator);
      }
    }
    return result;
  }

  int? indexWhereOrNull(bool Function(T) test, [int start = 0]) {
    final index = indexWhere(
      test,
      start,
    );
    if (index < 0) {
      return null;
    } else {
      return index;
    }
  }

  List<T> separate(
    T item, {
    bool around = false,
    bool between = true,
    bool onStart = false,
    bool onEnd = false,
    bool Function(T item)? skipBetween,
  }) {
    return smartInsert(
      skipBetween: skipBetween,
      around: (items) {
        return around ? item : null;
      },
      between: (items) {
        return between ? item : null;
      },
      onEnd: (items) {
        return onEnd ? item : null;
      },
      onStart: (items) {
        return onStart ? item : null;
      },
    );
  }

  List<T> smartInsert({
    T? Function(Iterable<T> items)? around,
    T? Function(Iterable<T> items)? between,
    T? Function(Iterable<T> items)? onEnd,
    T? Function(Iterable<T> items)? onStart,
    bool Function(T item)? skipBetween,
  }) {
    final betweenItem = between?.call(this);
    final aroundItem = around?.call(this);
    final startItem = onStart?.call(this);
    final endItem = onEnd?.call(this);
    final items = <T>[];
    if (betweenItem != null) {
      for (final itemRecord in indexed) {
        final index = itemRecord.$1;
        final item = itemRecord.$2;
        items.add(item);
        final skip = skipBetween?.call(item) ?? false;
        final isLast = isIndexLast(index);
        if (!isLast && !skip) {
          items.add(betweenItem);
        }
      }
    } else {
      items.addAll(toList());
    }
    if (aroundItem != null) {
      items.add(aroundItem);
      items.insert(0, aroundItem);
    } else {
      if (startItem != null) {
        items.insert(0, startItem);
      }
      if (endItem != null) {
        items.add(endItem);
      }
    }
    return items;
  }

  T? removeAtOrNull(int index) {
    try {
      return removeAt(index);
    } catch (e) {
      return null;
    }
  }

  T? removeLastOrNull() {
    try {
      return removeLast();
    } catch (e) {
      return null;
    }
  }
}
