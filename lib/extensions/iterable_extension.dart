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

  bool isIndexLast(int index) => index == length - 1;

  Iterable<T> separate(
    T item, {
    bool around = false,
    bool between = true,
    bool onStart = false,
    bool onEnd = false,
  }) {
    return smartInsert(
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

  Iterable<T> smartInsert({
    T? Function(Iterable<T> items)? around,
    T? Function(Iterable<T> items)? between,
    T? Function(Iterable<T> items)? onEnd,
    T? Function(Iterable<T> items)? onStart,
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
        final isLast = isIndexLast(index);
        if (!isLast) {
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
}
