import 'package:flutter/material.dart';
import 'package:flutter_toolkit/utils/executors/throttle_executor.dart';

class ThrottleListenableBuilder extends StatefulWidget {
  const ThrottleListenableBuilder({
    super.key,
    this.throttleDuration = const Duration(milliseconds: 400),
    required this.listenable,
    this.child,
    required this.builder,
  });

  final Duration throttleDuration;
  final Listenable listenable;
  final Widget? child;
  final TransitionBuilder builder;

  @override
  State<ThrottleListenableBuilder> createState() =>
      _ThrottleListenableBuilderState();
}

class _ThrottleListenableBuilderState extends State<ThrottleListenableBuilder> {
  late Listenable _listenable;
  final ThrottleExecutor _throttler = ThrottleExecutor();

  @override
  void initState() {
    super.initState();
    _listenable = widget.listenable;
    _addListener();
  }

  @override
  void didUpdateWidget(covariant ThrottleListenableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listenable != widget.listenable) {
      _removeListener();
      _listenable = widget.listenable;
      _addListener();
      _listener();
    }
  }

  void _listener() {
    _throttler.execute(
      duration: widget.throttleDuration,
      onAction: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
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
    return widget.builder(context, widget.child);
  }
}
