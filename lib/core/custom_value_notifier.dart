import 'package:flutter/foundation.dart';

abstract class CustomValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<T> {
  CustomValueNotifier() {
    _value = buildState();
    initState();
  }

  @protected
  T buildState();

  @protected
  @mustCallSuper
  void initState() {}

  @protected
  void updateValue(T Function(T old) onChange, {bool force = false}) {
    setValue(onChange(value), force: force);
  }

  @protected
  void setValue(T newValue, {bool force = false}) {
    if (_isDisposed) return;
    if (_value != newValue || force) {
      _previousValue = _value;
      _value = newValue;
      notifyListeners();
      onStateChanged(_previousValue, _value);
    }
  }

  late T _value;

  T? _previousValue;

  bool _isDisposed = false;

  T? get previousValue => _previousValue;

  bool get isDisposed => _isDisposed;

  @override
  T get value => _value;

  void onStateChanged(T? previous, T current) {}

  @override
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      super.dispose();
    }
  }
}
