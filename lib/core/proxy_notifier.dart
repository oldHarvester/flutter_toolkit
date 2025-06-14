import 'package:flutter/foundation.dart';
import 'package:flutter_toolkit/core/custom_value_notifier.dart';

/// `T` - ValueNotifier value, `Z` - listening ValueNotifier, `X` - proxy value from ValueNotifier
class ProxyNotifier<T, Z extends ValueListenable<T>, X>
    extends CustomValueNotifier<X> {
  ProxyNotifier({
    required this.notifier,
    required X Function(T value) onProxy,
  }) : _onProxy = onProxy;

  final Z notifier;
  final X Function(T value) _onProxy;

  @override
  void initState() {
    super.initState();
    notifier.addListener(_listener);
  }

  void _listener() {
    setValue(_onProxy(notifier.value));
  }

  @override
  X buildState() {
    return _onProxy(notifier.value);
  }

  @override
  void dispose() {
    notifier.removeListener(_listener);
    super.dispose();
  }
}
