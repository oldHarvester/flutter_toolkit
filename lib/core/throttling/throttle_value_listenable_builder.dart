import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toolkit/utils/executors/throttle_executor.dart';

class ThrottleValueListenableBuilder<T> extends StatefulWidget {
  const ThrottleValueListenableBuilder({
    super.key,
    this.throttleDuration = const Duration(milliseconds: 400),
    required this.listenable,
    required this.builder,
    this.child,
  });

  final Duration throttleDuration;
  final ValueListenable<T> listenable;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;

  @override
  State<ThrottleValueListenableBuilder<T>> createState() =>
      _ThrottleListenableBuilderState<T>();
}

class _ThrottleListenableBuilderState<T>
    extends State<ThrottleValueListenableBuilder<T>> {
  late ValueListenable<T> _listenable;
  late T _lastValue;
  final ThrottleExecutor _throttler = ThrottleExecutor();

  @override
  void initState() {
    super.initState();
    _listenable = widget.listenable;
    _lastValue = _listenable.value;
    _addListener();
  }

  @override
  void didUpdateWidget(covariant ThrottleValueListenableBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listenable != widget.listenable) {
      _removeListener();
      _listenable = widget.listenable;
      _addListener();
      _listener();
    }
  }

  void _listener() {
    if (_listenable.value != _lastValue) {
      _throttler.execute(
        duration: widget.throttleDuration,
        onAction: () {
          if (!mounted) return;
          setState(() {
            _lastValue = _listenable.value;
          });
        },
      );
    }
  }

  void _addListener() {
    _listenable.addListener(_listener);
  }

  void _removeListener() {
    _listenable.removeListener(_listener);
  }

  @override
  void dispose() {
    _throttler.stop();
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _lastValue, widget.child);
  }
}
