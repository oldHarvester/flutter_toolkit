import 'package:flutter/material.dart';

part 'input_builder_mixin.dart';

abstract class InputBuilderBase extends StatefulWidget {
  const InputBuilderBase({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onFocusChanged,
    required this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChanged;
  final ValueChanged<String>? onChanged;
}

abstract class InputBuilderState<T extends InputBuilderBase> extends State<T>
    with InputBuilderStateMixin<T> {}

abstract class InputBuilder extends StatefulWidget implements InputBuilderBase {
  const InputBuilder({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onFocusChanged,
  });

  @override
  final TextEditingController? controller;

  @override
  final FocusNode? focusNode;

  @override
  final ValueChanged<String>? onChanged;

  @override
  final ValueChanged<bool>? onFocusChanged;

  @override
  InputBuilderState createState();
}