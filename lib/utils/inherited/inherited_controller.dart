import 'package:flutter/material.dart';

abstract class InheritedController<T> extends InheritedWidget {
  const InheritedController({
    super.key,
    required super.child,
    required this.controller,
  });

  final T controller;

  @override
  bool updateShouldNotify(covariant InheritedController<T> oldWidget) {
    return oldWidget.controller != controller;
  }
}
