import 'package:flutter/material.dart';
import 'package:flutter_toolkit/extensions/list_extension.dart';

class GroupSpan {
  GroupSpan({
    required this.children,
  });

  final List<InlineSpan> children;
}

class SeparatedTextSpan extends StatelessWidget {
  const SeparatedTextSpan({
    super.key,
    required this.children,
    this.separator,
  });

  final List<GroupSpan> children;

  final InlineSpan? separator;

  List<GroupSpan> get _separatedChildren {
    if (separator == null) return children;
    return children
        .addSeparator(
          GroupSpan(
            children: [
              separator!,
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          for (final group in _separatedChildren) ...group.children,
        ],
      ),
    );
  }
}
