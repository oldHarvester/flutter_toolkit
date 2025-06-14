import 'dart:async';

import 'package:flutter/material.dart';

class TimerBuilder extends StatefulWidget {
  const TimerBuilder({
    super.key,
    required this.duration,
    required this.onCompleteBuilder,
    required this.placeholderBuilder,
  });

  final Duration duration;
  final Widget Function(BuildContext context, Widget placeholder)
      onCompleteBuilder;
  final Widget Function(BuildContext context) placeholderBuilder;

  @override
  State<TimerBuilder> createState() => _TimerBuilderState();
}

class _TimerBuilderState extends State<TimerBuilder> {
  late final Timer _timer;
  final ValueNotifier<bool> _isComplete = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      const Duration(seconds: 3),
      () {
        _isComplete.value = true;
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _isComplete.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isComplete,
      builder: (context, isComplete, child) {
        final placeholder = widget.placeholderBuilder(context);
        if (isComplete) {
          return widget.onCompleteBuilder(context, placeholder);
        } else {
          return placeholder;
        }
      },
    );
  }
}
