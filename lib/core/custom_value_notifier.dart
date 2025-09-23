import 'package:flutter/foundation.dart';

abstract class CustomValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<T> {
  CustomValueNotifier() {
    _value = buildState();
    _previousValue = value;
    initState();
  }

  @protected
  T buildState();

  @protected
  @mustCallSuper
  void initState() {}

  /// Changes state with given previous state and returns `true` if it changed after manipulation
  @protected
  bool updateValue(T Function(T old) onChange, {bool force = false}) {
    return setValue(onChange(value), force: force);
  }

  /// Changes state and returns `true` if it changed after manipulation
  @protected
  bool setValue(T newValue, {bool force = false}) {
    if (_isDisposed) return false;
    if (_value != newValue || force) {
      _previousValue = _value;
      _value = newValue;
      notifyListeners();
      onStateChanged(_previousValue, _value);
      return true;
    } else {
      return false;
    }
  }

  late T _value;

  late T _previousValue;

  bool _isDisposed = false;

  T? get previousValue => _previousValue;

  bool get isDisposed => _isDisposed;

  @override
  T get value => _value;

  void onStateChanged(T previous, T current) {}

  @override
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      super.dispose();
    }
  }
}
