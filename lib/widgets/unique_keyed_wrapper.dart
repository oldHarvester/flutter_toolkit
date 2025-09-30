import 'package:flutter/material.dart';

class UniqueKeyedWrapper<T> extends StatefulWidget {
  const UniqueKeyedWrapper({
    super.key,
    this.value,
    required this.child,
  });

  final T? value;
  final Widget child;

  @override
  State<UniqueKeyedWrapper> createState() => _UniqueKeyedWrapperState();
}

class _UniqueKeyedWrapperState extends State<UniqueKeyedWrapper> {
  UniqueKey _key = UniqueKey();

  @override
  void didUpdateWidget(covariant UniqueKeyedWrapper oldWidget) {
    if (oldWidget.value != widget.value) {
      _key = UniqueKey();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
