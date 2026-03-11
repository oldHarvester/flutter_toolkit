import 'package:flutter/material.dart';
import 'package:flutter_toolkit/extensions/map_extension.dart';

import 'ui_kit_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print(<int, String>{1: 'Some 1', 2: 'Some 2'}.difference(<int, String>{1: 'Some 2'}));
    return MaterialApp(
      home: UiKitExample(),
    );
  }
}
