import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'theme/flutter_toolkit_theme.dart';

class CustomSwitchButtonTheme extends Equatable {
  const CustomSwitchButtonTheme({
    this.disabledTrackColor = const Color(0xFF5E5E5E),
    this.activeTrackColor = const Color(0xFFFF570D),
    this.inactiveTrackColor = const Color(0xFF919090),
    this.duration = const Duration(milliseconds: 200),
    this.thumbActiveColor = Colors.white,
    this.thumbInactiveColor = Colors.white,
    this.thumbDisabledColor = const Color(0xFF919090),
    this.thumbDuration = const Duration(milliseconds: 400),
    this.thumbCurve = Curves.ease,
    this.curve = Curves.ease,
    this.size = const Size(40, 24),
  });

  final Color disabledTrackColor;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color thumbActiveColor;
  final Color thumbInactiveColor;
  final Color thumbDisabledColor;
  final Duration duration;
  final Curve curve;
  final Size size;
  final Duration thumbDuration;
  final Curve thumbCurve;

  @override
  List<Object?> get props => [
        disabledTrackColor,
        activeTrackColor,
        inactiveTrackColor,
        duration,
        curve,
      ];
}

class CustomSwitchButton extends StatefulWidget {
  const CustomSwitchButton({
    super.key,
    required this.value,
    this.duration,
    this.curve,
    this.onPressed,
  });

  final bool value;
  final Duration? duration;
  final Curve? curve;
  final VoidCallback? onPressed;

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  final ValueNotifier<bool> _touching = ValueNotifier(false);

  @override
  void dispose() {
    _touching.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alignment =
        widget.value ? Alignment.centerRight : Alignment.centerLeft;
    final isDisabled = widget.onPressed == null;
    final theme = FlutterToolkitTheme.of(context).switchButtonTheme;
    final trackColor = isDisabled
        ? theme.inactiveTrackColor
        : widget.value
            ? theme.activeTrackColor
            : theme.inactiveTrackColor;
    final size = theme.size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onPressed,
      onTapDown: (details) {
        _touching.value = true;
      },
      onTapUp: (details) {
        _touching.value = false;
      },
      onTapCancel: () {
        _touching.value = false;
      },
      child: AnimatedContainer(
        width: size.width,
        height: size.height,
        duration: theme.duration,
        curve: theme.curve,
        alignment: alignment,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: trackColor,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = constraints.maxHeight * 4 / 24;
            final size = constraints.maxHeight - (padding * 2);
            final halfWidth = (constraints.maxWidth - (padding * 2)) / 1.5;
            return Padding(
              padding: EdgeInsets.all(padding),
              child: ValueListenableBuilder(
                valueListenable: _touching,
                builder: (context, touching, _) {
                  return AnimatedContainer(
                    duration: theme.thumbDuration,
                    curve: theme.thumbCurve,
                    height: size,
                    width: touching && !isDisabled ? halfWidth : size,
                    decoration: BoxDecoration(
                      color: isDisabled
                          ? theme.thumbDisabledColor
                          : widget.value
                              ? theme.thumbActiveColor
                              : theme.thumbInactiveColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
