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
}
