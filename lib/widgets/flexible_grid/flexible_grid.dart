import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FlexibleGridIndex with EquatableMixin {
  const FlexibleGridIndex({
    required this.relativeIndex,
    required this.absoluteIndex,
    required this.colIndex,
    required this.rowIndex,
  });

  /// Index relative to non skipped or skipped items
  final int relativeIndex;

  /// Real index of the grid item
  final int absoluteIndex;
  final int colIndex;
  final int rowIndex;

  String displayPosition() {
    return '$colIndex:$rowIndex';
  }

  @override
  List<Object?> get props => [relativeIndex, absoluteIndex, rowIndex, colIndex];
}

class FlexibleGridConstraints with EquatableMixin {
  const FlexibleGridConstraints({
    required this.boxConstraints,
    required this.cellSize,
    required this.cols,
    required this.rows,
    required this.totalCount,
    required this.skippedElements,
    required this.colSpacing,
    required this.rowSpacing,
    required this.absoluteTotalCount,
  });

  final SplayTreeSet<int> skippedElements;
  final BoxConstraints boxConstraints;
  final int totalCount;
  final int absoluteTotalCount;
  final Size cellSize;
  final int rows;
  final int cols;
  final double rowSpacing;
  final double colSpacing;

  double get totalWidth {
    return cols * cellSize.width + (cols - 1) * rowSpacing;
  }

  ({int rowIndex, int colIndex}) rowColByIndex(int absoluteIndex) {
    return (rowIndex: absoluteIndex ~/ cols, colIndex: absoluteIndex % cols);
  }

  int toAbsoluteIndex(int index) {
    final last = skippedElements.lastOrNull;
    if (last == null) {
      return index;
    } else {
      return index + last;
    }
  }

  Offset cellOffset(int absoluteIndex) {
    final rowCol = rowColByIndex(absoluteIndex);
    final row = rowCol.rowIndex;
    final col = rowCol.colIndex;
    final colIndex = col % cols;
    final x = colIndex * (colSpacing + cellSize.width);
    final y = row * (rowSpacing + cellSize.height);
    return Offset(x, y);
  }

  Rect rowRect(int rowIndex) {
    final firstAbsoluteIndexInRow = rowIndex * cols;
    final firstRect = cellRect(firstAbsoluteIndexInRow);
    if (cols == 1) {
      return firstRect;
    } else {
      final lastAbsoluteIndexInRow = firstAbsoluteIndexInRow + cols - 1;
      final lastRect = cellRect(lastAbsoluteIndexInRow);
      return Rect.fromPoints(
        firstRect.topLeft,
        lastRect.bottomRight,
      );
    }
  }

  Rect cellRect(int absoluteIndex) {
    final offset = cellOffset(absoluteIndex);
    return Rect.fromLTWH(offset.dx, offset.dy, cellSize.width, cellSize.height);
  }

  @override
  List<Object?> get props => [
        cellSize,
        boxConstraints,
        totalCount,
        cellSize,
        rows,
        cols,
        rowSpacing,
        colSpacing,
      ];
}

class FlexibleGrid extends StatelessWidget {
  FlexibleGrid({
    super.key,
    required this.cols,
    required this.totalCount,
    required this.cellBuilder,
    this.skippedCellBuilder,
    this.aspectRatio = 1,
    this.colSpacing = 0,
    this.rowSpacing = 0,
    Iterable<int> skipElements = const Iterable.empty(),
    this.wrapper,
  }) : skipElements = SplayTreeSet.from(skipElements);

  final int totalCount;

  final int cols;

  final double colSpacing;

  final double rowSpacing;

  final SplayTreeSet<int> skipElements;

  final Widget Function(
    BuildContext context,
    FlexibleGridIndex gridIndex,
  ) cellBuilder;

  final Widget Function(
    BuildContext context,
    FlexibleGridIndex gridIndex,
  )? skippedCellBuilder;

  final Widget Function(
    BuildContext context,
    FlexibleGridConstraints gridConstraints,
    Widget table,
  )? wrapper;

  final double aspectRatio;

  int get rows => (totalCount / cols).ceil();

  int get absoluteTotalCount => rows * cols;

  Widget _buildGrid({
    required BuildContext context,
    required FlexibleGridConstraints gridConstraints,
  }) {
    var relativeSkippedIndex = -1;
    var relativeIndex = -1;
    final cellSize = gridConstraints.cellSize;
    final cellHeight = cellSize.height;
    return Column(
      spacing: gridConstraints.rowSpacing,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        rows,
        (rowIndex) {
          return SizedBox(
            height: cellHeight,
            child: SizedBox(
              width: gridConstraints.totalWidth,
              child: Row(
                spacing: gridConstraints.colSpacing,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  cols,
                  (colIndex) {
                    final absoluteIndex = rowIndex * cols + colIndex;
                    final skip =
                        absoluteIndex + 1 > gridConstraints.totalCount ||
                            skipElements.contains(absoluteIndex);
                    if (skip) {
                      relativeSkippedIndex++;
                    } else {
                      relativeIndex++;
                    }
                    return Expanded(
                      child: skip
                          ? skippedCellBuilder?.call(
                                context,
                                FlexibleGridIndex(
                                  relativeIndex: relativeSkippedIndex,
                                  absoluteIndex: absoluteIndex,
                                  colIndex: colIndex,
                                  rowIndex: rowIndex,
                                ),
                              ) ??
                              SizedBox.shrink()
                          : cellBuilder(
                              context,
                              FlexibleGridIndex(
                                absoluteIndex: absoluteIndex,
                                relativeIndex: relativeIndex,
                                colIndex: colIndex,
                                rowIndex: rowIndex,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colTotalSpacing = cols >= 2 ? cols * colSpacing : 0.0;
        final maxWidth = constraints.maxWidth;
        final availableWidth = maxWidth - colTotalSpacing;
        final cellWidth = availableWidth / cols;
        final cellHeight = cellWidth * aspectRatio;
        final cellSize = Size(cellWidth, cellHeight);
        final gridConstraints = FlexibleGridConstraints(
          absoluteTotalCount: absoluteTotalCount,
          colSpacing: colSpacing,
          rowSpacing: rowSpacing,
          skippedElements: skipElements,
          cols: cols,
          rows: rows,
          totalCount: totalCount,
          boxConstraints: constraints,
          cellSize: cellSize,
        );
        return wrapper?.call(
              context,
              gridConstraints,
              Builder(
                builder: (context) {
                  return _buildGrid(
                    context: context,
                    gridConstraints: gridConstraints,
                  );
                },
              ),
            ) ??
            _buildGrid(
              context: context,
              gridConstraints: gridConstraints,
            );
      },
    );
  }
}
