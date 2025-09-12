import 'package:flutter/material.dart';

class InheritedProvider {
  static T of<T extends InheritedWidget>(
    BuildContext context, {
    bool createDependency = true,
  }) {
    try {
      if (createDependency) {
        return context.dependOnInheritedWidgetOfExactType<T>()!;
      } else {
        return context.getInheritedWidgetOfExactType<T>()!;
      }
    } catch (e) {
      throw UnimplementedError('$T not found in BuildContext');
    }
  }

  static T? maybeOf<T extends InheritedWidget>(
    BuildContext context, {
    bool createDependency = true,
  }) {
    try {
      return of(
        context,
        createDependency: createDependency,
      );
    } catch (e) {
      return null;
    }
  }
}
