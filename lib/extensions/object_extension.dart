extension ObjectExtension on Object {
  T? castOrNull<T>() {
    if (this is T) {
      return this as T;
    } else {
      return null;
    }
  }
}
