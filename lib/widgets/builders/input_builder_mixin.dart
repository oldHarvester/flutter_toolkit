part of 'input_builder.dart';

mixin InputBuilderStateMixin<T extends InputBuilderBase> on State<T> {
  late TextEditingController _controller;

  late FocusNode _focusNode;

  late String _lastText;

  late bool _hasFocus;

  TextEditingController get controller => _controller;

  FocusNode get focusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _lastText = _controller.text;
    _focusNode = widget.focusNode ?? FocusNode();
    _hasFocus = _focusNode.hasFocus;
    _addEditingListener();
    _addFocusListener();
  }

  void _removeEditingListener() {
    _controller.removeListener(_editingListener);
  }

  void _addFocusListener() {
    _focusNode.addListener(_focusListener);
  }

  void _removeFocusListener() {
    _focusNode.removeListener(_focusListener);
  }

  void _addEditingListener() {
    _controller.addListener(_editingListener);
  }

  void _editingListener() {
    final currentText = _controller.text;
    if (currentText != _lastText) {
      _lastText = currentText;
      widget.onChanged?.call(currentText);
      onTextChanged(currentText);
    }
  }

  void onFocusChanged(bool hasFocus) {}

  void onTextChanged(String value) {}

  void _focusListener() {
    final hasFocus = _focusNode.hasFocus;
    if (_hasFocus != hasFocus) {
      _hasFocus = hasFocus;
      widget.onFocusChanged?.call(hasFocus);
      onFocusChanged(hasFocus);
    }
  }

  void _onEditingControllerChanged(
    TextEditingController? old,
    TextEditingController? current,
  ) {
    _removeEditingListener();
    if (old != null && current != null) {
      _controller = current;
    } else if (old != null && current == null) {
      _controller = TextEditingController();
    } else if (old == null && current != null) {
      final previous = _controller;
      _controller = current;
      previous.dispose();
    }
    _addEditingListener();
    _editingListener();
  }

  void _onFocusNodesChanged(FocusNode? old, FocusNode? current) {
    _removeFocusListener();

    if (old != null && current != null) {
      _focusNode = current;
    } else if (old != null && current == null) {
      _focusNode = FocusNode();
    } else if (old == null && current != null) {
      final previous = _focusNode;
      _focusNode = current;
      previous.dispose();
    }
    _addFocusListener();
    _focusListener();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    if (widget.controller != oldWidget.controller) {
      _onEditingControllerChanged(
        oldWidget.controller,
        widget.controller,
      );
    }
    if (widget.focusNode != oldWidget.focusNode) {
      _onFocusNodesChanged(oldWidget.focusNode, widget.focusNode);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }
}
