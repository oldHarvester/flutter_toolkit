import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toolkit/extensions/widget_states_extension.dart';
import 'package:flutter_toolkit/utils/inherited/inherited_provider.dart';

import 'theme/flutter_toolkit_theme.dart';

class FlexibleSwitchButtonTheme extends InheritedTheme {
  const FlexibleSwitchButtonTheme({
    super.key,
    required super.child,
    required this.data,
  });

  static FlexibleSwitchButtonThemeData of(
    BuildContext context, {
    bool createDependency = true,
  }) {
    return InheritedProvider.maybeOf<FlexibleSwitchButtonTheme>(
          context,
          createDependency: createDependency,
        )?.data ??
        FlutterToolkitTheme.of(
          context,
          createDependency: createDependency,
        ).switchButtonTheme;
  }

  final FlexibleSwitchButtonThemeData data;

  @override
  bool updateShouldNotify(covariant FlexibleSwitchButtonTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return FlexibleSwitchButtonTheme(
      data: data,
      child: child,
    );
  }
}

class FlexibleSwitchButtonThemeData extends Equatable {
  const FlexibleSwitchButtonThemeData({
    required this.trackColor,
    required this.thumbColor,
    required this.thumbBoxShadow,
    required this.trackBoxShadow,
    this.size = defaultSize,
    this.thumbCurve = defaultThumbCurve,
    this.thumbDuration = defaultThumbDuration,
    this.trackCurve = defaultTrackCurve,
    this.trackDuration = defaultTrackDuration,
    this.thumbPadding = defaultThumbPadding,
  });

  FlexibleSwitchButtonThemeData.fromStyle({
    Color activeTrackColor = defaultActiveTrackColor,
    Color inactiveTrackColor = defaultInactiveTrackColor,
    Color thumbActiveColor = defaultThumbActiveColor,
    Color thumbInactiveColor = defaultThumbInactiveColor,
    Color thumbDisabledColor = defaultThumbDisabledColor,
    Color disabledTrackColor = defaultDisabledTrackColor,
    List<BoxShadow> thumbBoxShadow = defaultThumbBoxShadow,
    List<BoxShadow> trackBoxShadow = defaultTrackBoxShadow,
    this.trackDuration = defaultTrackDuration,
    this.trackCurve = defaultTrackCurve,
    this.thumbCurve = defaultThumbCurve,
    this.thumbDuration = defaultThumbDuration,
    this.size = defaultSize,
    this.thumbPadding = defaultThumbPadding,
  })  : trackColor = WidgetStateProperty.resolveWith(
          (states) {
            if (states.disabled) {
              return disabledTrackColor;
            } else if (states.selected) {
              return activeTrackColor;
            } else {
              return inactiveTrackColor;
            }
          },
        ),
        thumbBoxShadow = WidgetStatePropertyAll(thumbBoxShadow),
        trackBoxShadow = WidgetStatePropertyAll(trackBoxShadow),
        thumbColor = WidgetStateProperty.resolveWith(
          (states) {
            if (states.disabled) {
              return thumbDisabledColor;
            } else if (states.selected) {
              return thumbActiveColor;
            } else {
              return thumbInactiveColor;
            }
          },
        );

  static const defaultTrackDuration = Duration(milliseconds: 200);

  static const defaultThumbDuration = Duration(milliseconds: 400);

  static const defaultSize = Size(40, 24);

  static const defaultTrackCurve = Curves.ease;

  static const defaultThumbCurve = Curves.ease;

  static const defaultDisabledTrackColor = Color(0xFF5E5E5E);

  static const defaultActiveTrackColor = Color(0xFFFF570D);

  static const defaultInactiveTrackColor = Color(0xFF919090);

  static const defaultThumbActiveColor = Colors.white;

  static const defaultThumbInactiveColor = Colors.white;

  static const defaultThumbDisabledColor = Color(0xFF919090);

  static const defaultThumbPadding = 4.0;

  static const defaultThumbBoxShadow = <BoxShadow>[];

  static const defaultTrackBoxShadow = <BoxShadow>[];

  final WidgetStateProperty<Color> trackColor;
  final WidgetStateProperty<Color> thumbColor;
  final WidgetStateProperty<List<BoxShadow>> thumbBoxShadow;
  final WidgetStateProperty<List<BoxShadow>> trackBoxShadow;
  final Duration thumbDuration;
  final Duration trackDuration;
  final Curve thumbCurve;
  final Curve trackCurve;
  final Size size;
  final double thumbPadding;

  @override
  List<Object?> get props => [
        trackColor,
        thumbColor,
        thumbDuration,
        trackDuration,
        trackCurve,
        thumbCurve,
        size,
        thumbPadding,
        thumbBoxShadow,
        trackBoxShadow,
      ];
}

class FlexibleSwitchButton extends StatefulWidget {
  const FlexibleSwitchButton({
    super.key,
    required this.value,
    this.thumbCurve,
    this.thumbDuration,
    this.trackCurve,
    this.trackDuration,
    this.onPressed,
    this.autofocus = false,
    this.canRequestFocus,
    this.onFocusChanged,
    this.focusNode,
    this.size,
    this.thumbColor,
    this.thumbPadding,
    this.trackColor,
    this.thumbBoxShadow,
    this.trackBoxShadow,
  });

  final bool value;
  final Duration? trackDuration;
  final Curve? trackCurve;
  final Duration? thumbDuration;
  final Curve? thumbCurve;
  final VoidCallback? onPressed;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChanged;
  final bool? canRequestFocus;
  final WidgetStateProperty<Color>? trackColor;
  final WidgetStateProperty<Color>? thumbColor;
  final WidgetStateProperty<List<BoxShadow>>? thumbBoxShadow;
  final WidgetStateProperty<List<BoxShadow>>? trackBoxShadow;
  final Size? size;
  final double? thumbPadding;

  @override
  State<FlexibleSwitchButton> createState() => _FlexibleSwitchButtonState();
}

class _FlexibleSwitchButtonState extends State<FlexibleSwitchButton> {
  late final WidgetStatesController _statesController;

  bool get disabled => widget.onPressed == null;

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController({
      if (disabled) WidgetState.disabled,
      if (widget.value) WidgetState.selected,
    });
  }

  @override
  void didUpdateWidget(covariant FlexibleSwitchButton oldWidget) {
    _statesController.update(WidgetState.disabled, disabled);
    _statesController.update(WidgetState.selected, widget.value);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alignment =
        widget.value ? Alignment.centerRight : Alignment.centerLeft;
    final theme = FlutterToolkitTheme.of(context).switchButtonTheme;
    final size = widget.size ?? theme.size;
    final thumbPadding = widget.thumbPadding ?? theme.thumbPadding;
    final thumbDuration = widget.thumbDuration ?? theme.thumbDuration;
    final thumbCurve = widget.thumbCurve ?? theme.thumbCurve;
    final trackDuration = widget.trackDuration ?? theme.trackDuration;
    final trackCurve = widget.trackCurve ?? theme.trackCurve;
    return Focus(
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      canRequestFocus: widget.canRequestFocus,
      onFocusChange: (value) {
        widget.onFocusChanged?.call(value);
        _statesController.update(WidgetState.focused, value);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onPressed,
        onTapDown: (details) {
          _statesController.update(WidgetState.pressed, true);
        },
        onTapUp: (details) {
          _statesController.update(WidgetState.pressed, false);
        },
        onTapCancel: () {
          _statesController.update(WidgetState.pressed, false);
        },
        child: MouseRegion(
          onEnter: (event) {
            _statesController.update(WidgetState.hovered, true);
          },
          onExit: (event) {
            _statesController.update(WidgetState.hovered, false);
          },
          child: ValueListenableBuilder(
            valueListenable: _statesController,
            builder: (context, states, child) {
              final touching = states.pressed;
              final disabled = states.disabled;
              final trackColor =
                  (widget.trackColor ?? theme.trackColor).resolve(states);
              final thumbColor =
                  (widget.thumbColor ?? theme.thumbColor).resolve(states);
              final thumbBoxShadow = (widget.thumbBoxShadow ?? theme.thumbBoxShadow).resolve(states);
              final trackBoxShadow = (widget.trackBoxShadow ?? theme.trackBoxShadow).resolve(states);
              return AnimatedContainer(
                width: size.width,
                height: size.height,
                duration: trackDuration,
                curve: trackCurve,
                alignment: alignment,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: trackColor,
                  boxShadow: trackBoxShadow,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final padding =
                        constraints.maxHeight * thumbPadding / size.height;
                    final thumbSize = constraints.maxHeight - (padding * 2);
                    final halfWidth =
                        (constraints.maxWidth - (padding * 2)) / 1.5;
                    return Padding(
                      padding: EdgeInsets.all(padding),
                      child: AnimatedContainer(
                        duration: thumbDuration,
                        curve: thumbCurve,
                        height: thumbSize,
                        width: touching && !disabled ? halfWidth : thumbSize,
                        decoration: BoxDecoration(
                          color: thumbColor,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: thumbBoxShadow,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
