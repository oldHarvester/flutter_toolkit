import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_toolkit/extensions/list_extension.dart';
import 'package:flutter_toolkit/utils/size_extent_util.dart';

mixin FixedExtentWidgetBuilderMixin {
  double resolveExtent();

  Widget resolveBuild(BuildContext context);
}

class AppBarBuilder extends StatelessWidget implements PreferredSizeWidget {
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
    this.height = 40,
    this.bottom,
  });

  final double height;
  final EdgeInsetsGeometry padding;
  final List<FixedExtentWidgetBuilderMixin> trailingActions;
  final List<FixedExtentWidgetBuilderMixin> leadingActions;
  final FixedExtentWidgetBuilderMixin? trailingSeparator;
  final FixedExtentWidgetBuilderMixin? leadingSeparator;
  final FixedExtentWidgetBuilderMixin? bottom;
  final Alignment alignment;
  final double contentSpacing;
  final Widget content;

  double get totalHeight =>
      height + (bottom == null ? 0 : bottom!.resolveExtent());

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
      itemSize: (index) => actions.elementAt(index).resolveExtent(),
      itemCount: actions.length,
      spacing: separator?.resolveExtent(),
      axis: Axis.horizontal,
    );
  }

  Widget _buildFixedExtent({
    required BuildContext context,
    required FixedExtentWidgetBuilderMixin builder,
  }) {
    return SizedBox(
      width: builder.resolveExtent(),
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
    final bottom = this.bottom;
    return SizedBox(
      height: totalHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
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
          ),
          if (bottom != null)
            SizedBox(
              height: bottom.resolveExtent(),
              child: bottom.resolveBuild(context),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(totalHeight);
}
