import 'package:flutter/material.dart';

extension ConstraintsExtension on BoxConstraints {
  Size calculateSize(double aspectRatio, {double? width, double? height}) {
    if (width != null) {
      // Если известна ширина, вычисляем высоту по aspectRatio
      final calculatedHeight = width / aspectRatio;
      return Size(width, calculatedHeight);
    } else if (height != null) {
      // Если известна высота, вычисляем ширину по aspectRatio
      final calculatedWidth = height * aspectRatio;
      return Size(calculatedWidth, height);
    } else {
      throw ArgumentError('Необходимо передать либо width, либо height');
    }
  }

  Widget buildAspectRatio({
    required double aspectRatio,
    required Widget child,
  }) {
    final heightBounded = hasBoundedHeight;
    final widthBounded = hasBoundedWidth;
    Size size;
    if (heightBounded) {
      size = calculateSize(aspectRatio, height: maxHeight);
    } else if (widthBounded) {
      size = calculateSize(aspectRatio, width: maxWidth);
    } else {
      return child;
    }
    return SizedBox(
      width: size.width,
      height: size.height,
      child: child,
    );
  }
}
