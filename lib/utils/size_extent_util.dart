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

  static double calculateTotalSpace({
    required EdgeInsets padding,
    required double Function(int index) itemSize,
    required int itemCount,
    required double? spacing,
    required Axis axis,
  }) {
    final paddingSize =
        axis == Axis.horizontal ? padding.horizontal : padding.vertical;

    if (itemCount == 0) return paddingSize;

    double totalItems = 0;
    for (int i = 0; i < itemCount; i++) {
      totalItems += itemSize(i);
    }

    final totalSpacing = (spacing ?? 0) * (itemCount - 1);

    return paddingSize + totalItems + totalSpacing;
  }
}
