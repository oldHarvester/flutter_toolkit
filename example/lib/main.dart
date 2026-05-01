import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp(
      home: UiKitExample(),
    );
  }
}
