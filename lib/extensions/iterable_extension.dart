extension IterableExtension<T> on Iterable<T> {
  T? itemAtOrNull(int index) {
    try {
      return elementAt(index);
    } catch (e) {
      return null;
    }
  }
}
