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
  const FlexibleGridConstraints._({
    required this.boxConstraints,
    required this.cellSize,
    required this.cols,
    required this.rows,
    required this.totalCount,
    required this.skippedElements,
  });

  factory FlexibleGridConstraints.fromBoxConstraints({
    required BoxConstraints constraints,
    required int totalCount,
    required int rows,
    required int cols,
    required double aspectRatio,
    required SplayTreeSet<int> skippedElements,
  }) {
    final maxWidth = constraints.maxWidth;
    final cellWidth = maxWidth / cols;
    final cellHeight = cellWidth * aspectRatio;
    final cellSize = Size(cellWidth, cellHeight);
    return FlexibleGridConstraints._(
      skippedElements: skippedElements,
      boxConstraints: constraints,
      cellSize: cellSize,
      cols: cols,
      rows: rows,
      totalCount: totalCount,
    );
  }

  final SplayTreeSet<int> skippedElements;
  final BoxConstraints boxConstraints;
  final int totalCount;
  final Size cellSize;
  final int rows;
  final int cols;

  @override
  List<Object?> get props => [
        cellSize,
        boxConstraints,
        totalCount,
        cellSize,
        rows,
        cols,
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
    Iterable<int> skipElements = const Iterable.empty(),
    this.wrapper,
  }) : skipElements = SplayTreeSet.from(skipElements);

  final int totalCount;

  final int cols;

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

  int get rows => (totalCount / cols).floor();

  Widget _buildGrid({
    required BuildContext context,
    required FlexibleGridConstraints gridConstraints,
  }) {
    var relativeSkippedIndex = -1;
    var relativeIndex = -1;
    final cellSize = gridConstraints.cellSize;
    final cellHeight = cellSize.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        rows,
        (rowIndex) {
          return SizedBox(
            height: cellHeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                cols,
                (colIndex) {
                  final absoluteIndex = rowIndex * cols + colIndex;
                  final skip = skipElements.contains(absoluteIndex);
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gridConstraints = FlexibleGridConstraints.fromBoxConstraints(
          skippedElements: skipElements,
          aspectRatio: aspectRatio,
          cols: cols,
          rows: rows,
          constraints: constraints,
          totalCount: totalCount,
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
