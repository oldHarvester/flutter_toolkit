import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_toolkit/extensions/list_extension.dart';
import 'package:flutter_toolkit/utils/size_extent_util.dart';

mixin FixedExtentWidgetBuilderMixin {
  double resolveExtent(BuildContext context);

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
    this.contentSpacing = 8.0,
    this.fixedHeight,
  });

  final double? fixedHeight;
  final EdgeInsetsGeometry padding;
  final List<FixedExtentWidgetBuilderMixin> trailingActions;
  final List<FixedExtentWidgetBuilderMixin> leadingActions;
  final FixedExtentWidgetBuilderMixin? trailingSeparator;
  final FixedExtentWidgetBuilderMixin? leadingSeparator;
  final Alignment alignment;
  final double contentSpacing;
  final Widget content;

  double trailingTotalExtent(BuildContext context) =>
      calculateExtent(context, trailingActions, trailingSeparator);

  double leadingTotalExtent(BuildContext context) =>
      calculateExtent(context, leadingActions, leadingSeparator);

  double occupyExtent(BuildContext context) => math.max(trailingTotalExtent(context), leadingTotalExtent(context));

  double calculateExtent(
    BuildContext context,
    List<FixedExtentWidgetBuilderMixin> actions,
    FixedExtentWidgetBuilderMixin? separator,
  ) {
    return SizeExtentUtil.calculateTotalSpace(
      padding: EdgeInsets.zero,
      itemSize: (index) => actions.elementAt(index).resolveExtent(context),
      itemCount: actions.length,
      spacing: separator?.resolveExtent(context),
      axis: Axis.horizontal,
    );
  }

  Widget _buildFixedExtent({
    required BuildContext context,
    required FixedExtentWidgetBuilderMixin builder,
  }) {
    return SizedBox(
      width: builder.resolveExtent(context),
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
    final occupyExtent = this.occupyExtent(context);
    return SizedBox(
      height: fixedHeight,
      child: Padding(
        padding: padding,
        child: Row(
          spacing: contentSpacing,
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
