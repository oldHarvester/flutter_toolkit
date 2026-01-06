import 'package:flutter/material.dart';

mixin WidgetStatesMixin<T extends StatefulWidget> on State<T> {
  bool? get isDisabled;

  bool? get isSelected;

  late final WidgetStatesController statesController;

  @override
  void initState() {
    super.initState();
    final isDisabled = this.isDisabled;
    final isSelected = this.isSelected;
    statesController = WidgetStatesController(
      {
        if (isDisabled != null && isDisabled) WidgetState.disabled,
        if (isSelected != null && isSelected) WidgetState.selected,
      },
    );
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    final isDisabled = this.isDisabled;
    final isSelected = this.isSelected;
    if (isDisabled != null) {
      statesController.update(WidgetState.disabled, isDisabled);
    }
    if (isSelected != null) {
      statesController.update(WidgetState.selected, isSelected);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    statesController.dispose();
    super.dispose();
  }
}
