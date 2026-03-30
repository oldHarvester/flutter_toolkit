import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toolkit/extensions/iterable_extension.dart';

import 'ui_kit_example.dart';

class TestModel with EquatableMixin {
  const TestModel({
    required this.id,
    required this.name,
  });

  TestModel copyWith({int? id, String? name}) {
    return TestModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // print(
    //   <int, String?>{
    //     1: 'Some 1',
    //     2: 'Some 2',
    //     3: null,
    //   }.union(
    //     <int, String?>{
    //       1: 'Some 2',
    //       3: ''
    //     },
    //   ),
    // );
    final test1 = [
      TestModel(id: 1, name: 'Daler'),
      TestModel(id: 2, name: 'Aziz'),
      TestModel(id: 3, name: 'Third'),
    ];
    final test2 = [
      // TestModel(id: 1, name: 'Daler'),
      TestModel(id: 0, name: 'Some'),
      TestModel(id: 2, name: 'Samir'),
    ];
    print(
      test1.calculateDifference(
        test2,
        resolveKey: (value) {
          return value.id;
        },
      ),
    );
    return MaterialApp(
      home: UiKitExample(),
    );
  }
}
