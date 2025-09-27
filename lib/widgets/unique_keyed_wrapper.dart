import 'package:flutter/material.dart';

class UniqueKeyedWrapper extends StatefulWidget {
  const UniqueKeyedWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<UniqueKeyedWrapper> createState() => _UniqueKeyedWrapperState();
}

class _UniqueKeyedWrapperState extends State<UniqueKeyedWrapper> {
  final UniqueKey _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
