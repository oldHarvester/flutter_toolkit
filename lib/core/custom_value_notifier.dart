import 'package:flutter/foundation.dart';

typedef CustomValueNotifierListener<T> = void Function(T previous, T current);

abstract class CustomValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<T> {
  CustomValueNotifier() {
    _value = buildState();
    _previousValue = value;
    initState();
  }

  final List<CustomValueNotifierListener<T>> _listeners = [];

  void addImprovedListener(CustomValueNotifierListener<T> listener) {
    _listeners.add(listener);
  }

  void removeImprovedListener(CustomValueNotifierListener<T> listener) {
    _listeners.remove(listener);
  }

  @protected
  T buildState();

  @protected
  @mustCallSuper
  void initState() {}

  void _notifyImprovedListeners(T previous, T current) {
    try {
      for (final listener in _listeners) {
        listener(previous, current);
      }
    } catch (_) {
      return;
    }
  }

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
      _notifyImprovedListeners(_previousValue, _value);
      onStateChanged(_previousValue, _value);
      return true;
    } else {
      return false;
    }
  }

  late T _value;

  late T _previousValue;

  bool _isDisposed = false;

  T get previousValue => _previousValue;

  bool get isDisposed => _isDisposed;

  @override
  T get value => _value;

  void onStateChanged(T previous, T current) {}

  @override
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      _listeners.clear();
      super.dispose();
    }
  }
}
