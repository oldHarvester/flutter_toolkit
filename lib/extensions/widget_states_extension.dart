import 'package:flutter/widgets.dart';

extension WidgetStatesExtension on Iterable<WidgetState> {
  bool get disabled => contains(WidgetState.disabled);

  bool get focused => contains(WidgetState.focused);

  bool get hovered => contains(WidgetState.hovered);

  bool get pressed => contains(WidgetState.pressed);

  bool get dragged => contains(WidgetState.dragged);

  bool get selected => contains(WidgetState.selected);

  bool get scrolledUnder => contains(WidgetState.scrolledUnder);

  bool get error => contains(WidgetState.error);
}
