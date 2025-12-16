import 'package:flutter/material.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class FlexibleGridExample extends StatefulWidget {
  const FlexibleGridExample({super.key});

  @override
  State<FlexibleGridExample> createState() => _FlexibleGridExampleState();
}

class _FlexibleGridExampleState extends State<FlexibleGridExample> {
  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: Colors.black,
      width: 0.1,
    );
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: FlexibleGrid(
            colSpacing: 10,
            rowSpacing: 10,
            cols: 10,
            totalCount: 105,
            skipElements: Iterable.generate(13),
            wrapper: (context, gridConstraints, table) {
              return Stack(
                alignment: Alignment.topLeft,
                children: [
                  table,
                  ...List.generate(
                    gridConstraints.skippedElements.length,
                    (index) {
                      final skippedIndex = gridConstraints.skippedElements
                          .elementAt(index);
                      final offset = gridConstraints.cellOffset(skippedIndex);
                      return Positioned(
                        left: offset.dx,
                        top: offset.dy,
                        child: Container(
                          width: gridConstraints.cellSize.width,
                          height: gridConstraints.cellSize.height,
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.red : Colors.green,
                            border: border,
                          ),
                          child: Center(
                            child: Text(
                              skippedIndex.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
            skippedCellBuilder: (context, gridIndex) {
              return Container(
                decoration: BoxDecoration(),
              );
            },
            cellBuilder: (context, gridIndex) {
              return Container(
                decoration: BoxDecoration(
                  border: border,
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                        gridIndex.displayPosition(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
