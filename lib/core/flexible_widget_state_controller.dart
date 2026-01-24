import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class FlexibleWidgetStateController extends WidgetStatesController {
  FlexibleWidgetStateController(super.value);

  void changeStates(Set<WidgetState> states) {
    final changed = !DeepCollectionEquality().equals(states, value);
    value = states;
    if (changed) {
      notifyListeners();
    }
  }
}
