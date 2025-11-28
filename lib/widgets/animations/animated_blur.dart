import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // TODO: need to remove this dependency latter

class AnimatedBlur extends StatefulWidget {
  const AnimatedBlur({
    super.key,
    required this.animate,
    this.duration = const Duration(milliseconds: 200),
    required this.child,
  });

  final bool animate;
  final Widget child;
  final Duration duration;

  @override
  State<AnimatedBlur> createState() => _AnimatedBlurState();
}

class _AnimatedBlurState extends State<AnimatedBlur>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.animate ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedBlur oldWidget) {
    if (oldWidget.animate != widget.animate) {
      _animationController.animateTo(widget.animate ? 1 : 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      controller: _animationController,
      autoPlay: false,
      effects: [
        BlurEffect(
          duration: widget.duration,
          begin: const Offset(0, 0),
          end: const Offset(10, 10),
        ),
      ],
      child: widget.child,
    );
  }
}
