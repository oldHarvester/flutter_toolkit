import 'package:flutter/cupertino.dart';

class FlexibleValueNotifier<T> extends ValueNotifier<T> {
  FlexibleValueNotifier(super.value);

  bool _disposed = false;

  bool get disposed => _disposed;

  @override
  set value(T newValue) {
    if (disposed) return;
    super.value = newValue;
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    super.dispose();
  }
}
