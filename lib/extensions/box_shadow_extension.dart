import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

class BoxShadowInsets with EquatableMixin {
  const BoxShadowInsets({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  const BoxShadowInsets.zero()
      : left = 0,
        right = 0,
        top = 0,
        bottom = 0;

  factory BoxShadowInsets.fromIterable(Iterable<BoxShadow> shadows) {
    double left = 0, top = 0, right = 0, bottom = 0;

    for (final s in shadows) {
      // Насколько далеко тень "вылезает" за пределы карточки.
      // blurRadius + spreadRadius — это разброс во все стороны,
      // dx/dy сдвигают центр тени.
      final extent = s.blurRadius + s.spreadRadius;

      left = math.max(left, extent - s.offset.dx);
      top = math.max(top, extent - s.offset.dy);
      right = math.max(right, extent + s.offset.dx);
      bottom = math.max(bottom, extent + s.offset.dy);
    }

    return BoxShadowInsets(left: left, top: top, right: right, bottom: bottom);
  }

  final double left;
  final double top;
  final double right;
  final double bottom;
  
  @override
  List<Object?> get props => [left, top, right, bottom];
}

extension BoxShadowListX on Iterable<BoxShadow> {
  BoxShadowInsets get shadowInsets => BoxShadowInsets.fromIterable(this);
}

extension BoxShadowExtension on BoxShadow {
  BoxShadowInsets get shadowInsets => BoxShadowInsets.fromIterable([this]);
}
