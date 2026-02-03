import 'package:flutter/material.dart';

abstract class InputBuilder extends StatefulWidget {
  const InputBuilder({
    super.key,
    this.inputController,
    this.inputNode,
    this.onInputChanged,
    this.onInputFocusChanged,
  });

  final TextEditingController? inputController;
  final FocusNode? inputNode;
  final ValueChanged<bool>? onInputFocusChanged;
  final ValueChanged<String>? onInputChanged;

  @override
  InputBuilderState createState();
}

abstract class InputBuilderState<T extends InputBuilder> extends State<T> {
  late TextEditingController _editingController;

  late FocusNode _editingNode;

  late String _lastText;

  late bool _hasFocus;

  TextEditingController get inputController => _editingController;

  FocusNode get inputNode => _editingNode;

  @override
  void initState() {
    super.initState();
    _editingController = widget.inputController ?? TextEditingController();
    _lastText = _editingController.text;
    _editingNode = widget.inputNode ?? FocusNode();
    _hasFocus = _editingNode.hasFocus;
  }

  void _removeEditingListener() {
    _editingController.removeListener(_editingListener);
  }

  void _addFocusListener() {
    _editingNode.addListener(_focusListener);
  }

  void _removeFocusListener() {
    _editingNode.removeListener(_focusListener);
  }

  void _addEditingListener() {
    _editingController.addListener(_editingListener);
  }

  void _editingListener() {
    final currentText = _editingController.text;
    if (currentText != _lastText) {
      _lastText = currentText;
      widget.onInputChanged?.call(currentText);
    }
  }

  void _focusListener() {
    final hasFocus = _editingNode.hasFocus;
    if (_hasFocus != hasFocus) {
      _hasFocus = hasFocus;
      widget.onInputFocusChanged?.call(hasFocus);
    }
  }

  void _onEditingControllerChanged(
    TextEditingController? old,
    TextEditingController? current,
  ) {
    _removeEditingListener();
    if (old != null && current != null) {
      _editingController = current;
    } else if (old != null && current == null) {
      _editingController = TextEditingController();
    } else if (old == null && current != null) {
      final previous = _editingController;
      _editingController = current;
      previous.dispose();
    }
    _addEditingListener();
    _editingListener();
  }

  void _onFocusNodesChanged(FocusNode? old, FocusNode? current) {
    _removeFocusListener();
    if (old != null && current != null) {
      _editingNode = current;
    } else if (old != null && current == null) {
      _editingNode = FocusNode();
    } else if (old == null && current != null) {
      final previous = _editingNode;
      _editingNode = current;
      previous.dispose();
    }
    _addFocusListener();
    _focusListener();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    if (widget.inputController != oldWidget.inputController) {
      _onEditingControllerChanged(
        oldWidget.inputController,
        widget.inputController,
      );
    }
    if (widget.inputNode != oldWidget.inputNode) {
      _onFocusNodesChanged(oldWidget.inputNode, widget.inputNode);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.inputController == null) {
      _editingController.dispose();
    }
    if (widget.inputNode == null) {
      _editingNode.dispose();
    }
    super.dispose();
  }
}
