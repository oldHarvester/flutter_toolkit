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
    return elementAtOrNull(index++);
  }

  T? previousFrom(int index) {
    if (index <= 0) return null;
    return elementAtOrNull(index--);
  }

  Iterable<T> paginate(int page, int limit) {
    final startIndex = page * limit;
    return skip(startIndex).take(limit);
  }
}
