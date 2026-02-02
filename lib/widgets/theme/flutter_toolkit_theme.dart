import 'package:flutter/material.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class FlutterToolkitThemeData {
  const FlutterToolkitThemeData.raw({
    required this.switchButtonTheme,
  });

  factory FlutterToolkitThemeData({
    FlexibleSwitchButtonThemeData? switchButtonTheme,
  }) {
    switchButtonTheme ??= FlexibleSwitchButtonThemeData.fromStyle();
    return FlutterToolkitThemeData.raw(
      switchButtonTheme: switchButtonTheme,
    );
  }

  final FlexibleSwitchButtonThemeData switchButtonTheme;
}

class FlutterToolkitTheme extends StatelessWidget {
  const FlutterToolkitTheme({
    super.key,
    required this.data,
    required this.child,
  });

  static FlutterToolkitThemeData of(
    BuildContext context, {
    bool createDependency = true,
  }) {
    return InheritedProvider.maybeOf<_InheritedTheme>(
          context,
          createDependency: createDependency,
        )?.data ??
        FlutterToolkitThemeData();
  }

  final FlutterToolkitThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(
      data: data,
      child: child,
    );
  }
}

class _InheritedTheme extends InheritedTheme {
  const _InheritedTheme({
    required super.child,
    required this.data,
  });
  final FlutterToolkitThemeData data;

  @override
  bool updateShouldNotify(covariant _InheritedTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return FlutterToolkitTheme(data: data, child: child);
  }
}
