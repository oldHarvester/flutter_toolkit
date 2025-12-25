import 'package:flutter_toolkit/core/custom_value_notifier.dart';

class ExtendedValueNotifier<T> extends CustomValueNotifier<T> {
  ExtendedValueNotifier(T value) : _value = value;
  final T _value;

  @override
  T buildState() {
    return _value;
  }
}
