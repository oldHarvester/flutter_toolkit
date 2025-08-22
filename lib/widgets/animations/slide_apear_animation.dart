import 'package:flutter/widgets.dart';

enum SlideApearAnimationType {
  left(Offset(-0.1, 0)),
  right(Offset(0.1, 0)),
  top(Offset(0, -0.1)),
  bottom(Offset(0, 0.1)),
  none(Offset.zero),
  ;

  const SlideApearAnimationType(this.offset);
  final Offset offset;
}

class SlideApearAnimation extends StatefulWidget {
  const SlideApearAnimation({
    super.key,
    required this.show,
    required this.type,
    this.slideCurve = Curves.easeOutSine,
    this.slideReverseDuration,
    this.slideDuration = const Duration(milliseconds: 300),
    this.slideReverseCurve,
    this.persistHidenChild = false,
    required this.child,
  });

  final bool show;
  final Curve slideCurve;
  final Curve? slideReverseCurve;
  final Duration? slideReverseDuration;
  final Duration slideDuration;
  final SlideApearAnimationType type;
  final bool persistHidenChild;
  final Widget child;

  @override
  State<SlideApearAnimation> createState() => SlideApearAnimationState();
}

class SlideApearAnimationState extends State<SlideApearAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<Offset> _slideAnimation;

  final ValueNotifier<bool> _isAnimating = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.slideDuration,
      reverseDuration: widget.slideReverseDuration,
      value: widget.show ? 1 : 0,
    );
    _animationController.addStatusListener(_animationStatusListener);
    _slideAnimation = Tween<Offset>(
      begin: widget.type.offset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.slideCurve,
        reverseCurve: widget.slideReverseCurve,
      ),
    );
    _runAnimation(widget.show);
  }

  void _animationStatusListener(AnimationStatus status) {
    final isCompleted = status == AnimationStatus.completed;
    _isAnimating.value = !isCompleted;
  }

  TickerFuture _runAnimation(bool show) {
    if (show) {
      return _animationController.animateTo(1);
    } else {
      return _animationController.animateTo(0);
    }
  }

  @override
  void didUpdateWidget(covariant SlideApearAnimation oldWidget) {
    if (oldWidget.show != widget.show) {
      _runAnimation(widget.show);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _isAnimating.dispose();
    _animationController.removeStatusListener(_animationStatusListener);
    _animationController.dispose();
    super.dispose();
  }

  Widget clearHiddenBuilder({
    required bool enable,
    required Widget child,
  }) {
    if (!enable) {
      return child;
    }

    return ValueListenableBuilder(
      valueListenable: _isAnimating,
      builder: (context, isAnimating, _) {
        final show = widget.show;
        final clear = !show && !isAnimating;
        return clear ? const SizedBox.shrink() : child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.show,
      child: AnimatedOpacity(
        opacity: widget.show ? 1 : 0,
        duration: widget.slideDuration,
        child: SlideTransition(
          position: _slideAnimation,
          child: clearHiddenBuilder(
            enable: !widget.persistHidenChild,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
