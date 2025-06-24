import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_toolkit/widgets/custom_switch_button.dart';

class FlutterToolkitTheme extends InheritedWidget {
  const FlutterToolkitTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final FlutterToolkitThemeData data;

  static FlutterToolkitThemeData of(BuildContext context) {
    try {
      final provider =
          context.dependOnInheritedWidgetOfExactType<FlutterToolkitTheme>()!;
      return provider.data;
    } catch (e) {
      return const FlutterToolkitThemeData();
    }
  }

  @override
  bool updateShouldNotify(covariant FlutterToolkitTheme oldWidget) {
    return oldWidget.data != data;
  }
}

class FlutterToolkitThemeData extends Equatable {
  const FlutterToolkitThemeData({
    this.switchButtonTheme = const CustomSwitchButtonTheme(),
  });

  final CustomSwitchButtonTheme switchButtonTheme;

  @override
  List<Object?> get props => [switchButtonTheme];
}
