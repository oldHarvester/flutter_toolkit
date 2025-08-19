import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProxyValueListenableBuilder<T, Z> extends StatefulWidget {
  const ProxyValueListenableBuilder({
    super.key,
    required this.transform,
    required this.valueListenable,
    required this.builder,
    this.child,
  });

  final ValueListenable<T> valueListenable;
  final Z Function(T value) transform;
  final Widget Function(BuildContext context, Z value, Widget? child) builder;
  final Widget? child;

  @override
  State<ProxyValueListenableBuilder<T, Z>> createState() =>
      _ProxyValueListenableBuilderState();
}

class _ProxyValueListenableBuilderState<T, Z>
    extends State<ProxyValueListenableBuilder<T, Z>> {
  late ValueListenable<T> _listenable;
  late final ValueNotifier<Z> _proxyListenable;

  @override
  void initState() {
    super.initState();
    _initializeListener(widget.valueListenable);
  }

  Z get transformedValue {
    return widget.transform(_listenable.value);
  }

  void _listener() {
    _proxyListenable.value = transformedValue;
  }

  void _initializeListener(ValueListenable<T> listenable) {
    _listenable = listenable;
    _proxyListenable = ValueNotifier(transformedValue);
    _listenable.addListener(_listener);
  }

  void _clearListenable() {
    _listenable.removeListener(_listener);
  }

  @override
  void didUpdateWidget(covariant ProxyValueListenableBuilder<T, Z> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable) {
      _clearListenable();
      _initializeListener(widget.valueListenable);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _clearListenable();
    _proxyListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _proxyListenable,
      builder: (context, value, child) {
        return widget.builder(context, value, child);
      },
      child: widget.child,
    );
  }
}
