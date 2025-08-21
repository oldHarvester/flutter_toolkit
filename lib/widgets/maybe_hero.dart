import 'package:flutter/material.dart';

class MaybeHero extends StatelessWidget {
  const MaybeHero({
    super.key,
    this.tag,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.transitionOnUserGestures = false,
    required this.child,
  });

  final Object? tag;
  final Widget child;
  final Tween<Rect?> Function(Rect? begin, Rect? end)? createRectTween;
  final Widget Function(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  )? flightShuttleBuilder;
  final Widget Function(BuildContext context, Size heroSize, Widget child)?
      placeholderBuilder;
  final bool transitionOnUserGestures;

  Widget _buildWithHero({
    required Object tag,
    required Widget child,
  }) {
    return Hero(
      tag: tag,
      createRectTween: createRectTween,
      flightShuttleBuilder: flightShuttleBuilder,
      placeholderBuilder: placeholderBuilder,
      transitionOnUserGestures: transitionOnUserGestures,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tag = this.tag;
    if (tag != null) {
      return _buildWithHero(
        tag: tag,
        child: child,
      );
    } else {
      return child;
    }
  }
}
