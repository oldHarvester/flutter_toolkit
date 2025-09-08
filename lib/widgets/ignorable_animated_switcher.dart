import 'package:flutter/material.dart';

class IgnorableAnimatedSwitcher extends AnimatedSwitcher {
  IgnorableAnimatedSwitcher({
    super.key,
    super.reverseDuration,
    super.switchInCurve,
    super.switchOutCurve,
    super.transitionBuilder,
    super.duration = const Duration(milliseconds: 400),
    super.child,
  }) : super(
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ...previousChildren.map(
                  (e) => IgnorePointer(
                    child: e,
                  ),
                ),
                if (currentChild != null) currentChild,
              ],
            );
          },
        );
}
