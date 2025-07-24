import 'package:flutter/foundation.dart';
import 'package:flutter_toolkit/core/custom_value_notifier.dart';

/// `T` - ValueNotifier value, `Z` - listening ValueNotifier, `X` - proxy value from ValueNotifier
abstract class ProxyNotifier<T, Z extends ValueListenable<T>, X>
    extends CustomValueNotifier<X> {
  ProxyNotifier({
    required this.notifier,
  });

  final Z notifier;

  X onProxy(T value);

  @override
  void initState() {
    super.initState();
    notifier.addListener(_listener);
  }

  void _listener() {
    setValue(onProxy(notifier.value));
  }

  @override
  X buildState() {
    return onProxy(notifier.value);
  }

  @override
  void dispose() {
    notifier.removeListener(_listener);
    super.dispose();
  }
}
