import 'package:flutter/material.dart';

class AnimatedColorBuilder extends StatefulWidget {
  const AnimatedColorBuilder({
    super.key,
    required this.builder,
    required this.color,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linear,
  });

  final Color color;
  final Duration? duration;
  final Curve curve;
  final Widget Function(BuildContext context, Color color) builder;

  @override
  State<AnimatedColorBuilder> createState() => _AnimatedColorBuilderState();
}

class _AnimatedColorBuilderState extends State<AnimatedColorBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void didUpdateWidget(covariant AnimatedColorBuilder oldWidget) {
    if (widget.color != oldWidget.color) {
      _controller.reset();
      _controller.forward();
      _animation = _prepareAnimation(
        begin: oldWidget.color,
        end: widget.color,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  Animation<Color?> _prepareAnimation({Color? begin, Color? end}) {
    return ColorTween(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = _prepareAnimation(
      begin: widget.color,
      end: widget.color,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final color = _animation.value ?? widget.color;
        return widget.builder(context, color);
      },
    );
  }
}
