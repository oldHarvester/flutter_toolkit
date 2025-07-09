import 'package:flutter/material.dart';

class ListRemoveAnimation extends StatelessWidget {
  const ListRemoveAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.axis = Axis.vertical,
  });

  final Animation<double> animation;
  final Widget child;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );
    return FadeTransition(
      opacity: curved,
      child: SizeTransition(
        sizeFactor: curved,
        axis: axis,
        child: child,
      ),
    );
  }
}
