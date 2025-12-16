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
    );
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: FlexibleGrid(
            cols: 10,
            skipElements: {5, 4, 3, 2, 1},
            wrapper: (context, gridConstraints, table) {
              return Stack(
                children: [
                  table,
                ],
              );
            },
            totalCount: 100,
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
