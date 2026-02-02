import 'package:flutter/material.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class UiKitExample extends StatefulWidget {
  const UiKitExample({super.key});

  @override
  State<UiKitExample> createState() => _UiKitExampleState();
}

class _UiKitExampleState extends State<UiKitExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlexibleSwitchButton(
                value: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
