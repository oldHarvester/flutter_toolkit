import 'package:flutter/cupertino.dart';

abstract final class SizeExtentUtil {
  static double calculateExtent({
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    double spacing = 0,
    required double availableExtent,
    required int count,
  }) {
    if (count <= 0) {
      throw ArgumentError('Count must be greater than zero');
    }

    final totalSpacing = spacing * (count - 1);
    final totalPadding = padding.horizontal;
    final usableSpace = availableExtent - totalSpacing - totalPadding;

    if (usableSpace <= 0) {
      throw ArgumentError('Available extent is too small for given parameters');
    }

    return usableSpace / count;
  }
}
