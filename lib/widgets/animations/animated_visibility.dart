import 'package:flutter/material.dart';

class AnimatedVisibility extends StatefulWidget {
  const AnimatedVisibility({
    super.key,
    required this.show,
    this.sizeAxisAlignment = 0.0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 400),
    this.reverseDuration,
    this.reverseCurve,
    this.animateSize = true,
    this.sizeAxis = Axis.vertical,
    this.sizeFixedCrossAxisSizeFactor,
    this.disposeWhenHidden = true,
    this.hiddenBuilder,
    required this.child,
  });

  final bool show;
  final Duration duration;
  final Curve curve;
  final bool disposeWhenHidden;
  final bool animateSize;
  final double sizeAxisAlignment;
  final Axis sizeAxis;
  final double? sizeFixedCrossAxisSizeFactor;
  final Duration? reverseDuration;
  final Curve? reverseCurve;
  final Widget Function(BuildContext context)? hiddenBuilder;
  final Widget child;

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final ValueNotifier<bool> _visible;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: widget.show ? 1 : 0,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
    );
    _visible = ValueNotifier(_animationController.value > 0);
    _animationController.addListener(_onAnimationChanges);
    super.initState();
  }

  void _onAnimationChanges() {
    if (_animationController.value > 0) {
      _visible.value = true;
    } else {
      _visible.value = false;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedVisibility oldWidget) {
    if (oldWidget.show != widget.show) {
      if (widget.show) {
        _animationController.animateTo(
          1,
          duration: _animationController.duration,
        );
      } else {
        _animationController.animateTo(
          0,
          duration: _animationController.reverseDuration,
        );
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.removeListener(_onAnimationChanges);
    _animationController.dispose();
    _visible.dispose();
    super.dispose();
  }

  Widget _animateWithSize({
    required Widget child,
    required Animation<double> sizeFactor,
  }) {
    return SizeTransition(
      sizeFactor: sizeFactor,
      axisAlignment: widget.sizeAxisAlignment,
      axis: widget.sizeAxis,
      fixedCrossAxisSizeFactor: widget.sizeFixedCrossAxisSizeFactor,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve,
    );
    final fadeWidget = FadeTransition(
      opacity: animation,
      child: IgnorePointer(
        ignoring: !widget.show,
        child: !widget.disposeWhenHidden
            ? widget.child
            : ValueListenableBuilder(
                valueListenable: _visible,
                builder: (context, isVisible, child) {
                  return isVisible
                      ? widget.child
                      : widget.hiddenBuilder?.call(context) ?? const SizedBox();
                },
              ),
      ),
    );
    return widget.animateSize
        ? _animateWithSize(
            child: fadeWidget,
            sizeFactor: animation,
          )
        : fadeWidget;
  }
}
