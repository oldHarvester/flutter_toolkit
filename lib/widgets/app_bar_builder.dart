import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_toolkit/extensions/list_extension.dart';
import 'package:flutter_toolkit/utils/size_extent_util.dart';

mixin FixedExtentWidgetBuilderMixin {
  double get extent;

  Widget resolveBuild(BuildContext context);
}

class AppBarBuilder extends StatelessWidget {
  const AppBarBuilder({
    super.key,
    required this.content,
    required this.trailingActions,
    required this.leadingActions,
    this.leadingSeparator,
    this.trailingSeparator,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.fixedHeight,
  });

  final double? fixedHeight;
  final EdgeInsetsGeometry padding;
  final List<FixedExtentWidgetBuilderMixin> trailingActions;
  final List<FixedExtentWidgetBuilderMixin> leadingActions;
  final FixedExtentWidgetBuilderMixin? trailingSeparator;
  final FixedExtentWidgetBuilderMixin? leadingSeparator;
  final Alignment alignment;
  final Widget content;

  double get trailingTotalExtent =>
      calculateExtent(trailingActions, trailingSeparator);

  double get leadingTotalExtent =>
      calculateExtent(leadingActions, leadingSeparator);

  double get occupyExtent => math.max(trailingTotalExtent, leadingTotalExtent);

  double calculateExtent(
    List<FixedExtentWidgetBuilderMixin> actions,
    FixedExtentWidgetBuilderMixin? separator,
  ) {
    return SizeExtentUtil.calculateTotalSpace(
      padding: EdgeInsets.zero,
      itemSize: (index) => actions.elementAt(index).extent,
      itemCount: actions.length,
      spacing: separator?.extent,
      axis: Axis.horizontal,
    );
  }

  Widget _buildFixedExtent({
    required BuildContext context,
    required FixedExtentWidgetBuilderMixin builder,
  }) {
    return SizedBox(
      width: builder.extent,
      child: builder.resolveBuild(context),
    );
  }

  Widget _buildActions({
    required MainAxisAlignment mainAxisAlignment,
    required BuildContext context,
    required List<FixedExtentWidgetBuilderMixin> actions,
    required FixedExtentWidgetBuilderMixin? separator,
  }) {
    final children = List<Widget>.generate(
      actions.length,
      (index) {
        return _buildFixedExtent(
          context: context,
          builder: actions[index],
        );
      },
    );

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: separator == null
          ? children
          : children.separate(
              _buildFixedExtent(
                context: context,
                builder: separator,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fixedHeight,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            SizedBox(
              width: occupyExtent,
              child: _buildActions(
                separator: leadingSeparator,
                mainAxisAlignment: MainAxisAlignment.start,
                context: context,
                actions: leadingActions,
              ),
            ),
            Expanded(
              child: Align(
                alignment: alignment,
                child: content,
              ),
            ),
            SizedBox(
              width: occupyExtent,
              child: _buildActions(
                separator: trailingSeparator,
                mainAxisAlignment: MainAxisAlignment.end,
                context: context,
                actions: trailingActions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
