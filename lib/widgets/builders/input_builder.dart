import 'package:flutter/material.dart';

abstract class InputBuilder extends StatefulWidget {
  const InputBuilder({
    super.key,
    this.editingController,
    this.editingNode,
    this.onEditingChanged,
    this.onEditingFocusChanged,
  });

  final TextEditingController? editingController;
  final FocusNode? editingNode;
  final ValueChanged<bool>? onEditingFocusChanged;
  final ValueChanged<String>? onEditingChanged;

  @override
  InputBuilderState createState();
}

abstract class InputBuilderState<T extends InputBuilder> extends State<T> {
  late TextEditingController _editingController;

  late FocusNode _editingNode;

  late String _lastText;

  late bool _hasFocus;

  TextEditingController get editingController => _editingController;

  FocusNode get editingNode => _editingNode;

  @override
  void initState() {
    super.initState();
    _editingController = widget.editingController ?? TextEditingController();
    _lastText = _editingController.text;
    _editingNode = widget.editingNode ?? FocusNode();
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
      widget.onEditingChanged?.call(currentText);
    }
  }

  void _focusListener() {
    final hasFocus = _editingNode.hasFocus;
    if (_hasFocus != hasFocus) {
      _hasFocus = hasFocus;
      widget.onEditingFocusChanged?.call(hasFocus);
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
    if (widget.editingController != oldWidget.editingController) {
      _onEditingControllerChanged(
        oldWidget.editingController,
        widget.editingController,
      );
    }
    if (widget.editingNode != oldWidget.editingNode) {
      _onFocusNodesChanged(oldWidget.editingNode, widget.editingNode);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.editingController == null) {
      _editingController.dispose();
    }
    if (widget.editingNode == null) {
      _editingNode.dispose();
    }
    super.dispose();
  }
}
