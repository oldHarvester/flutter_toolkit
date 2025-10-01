import 'package:flutter/material.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class AspectRatioBuilder extends StatelessWidget {
  const AspectRatioBuilder({
    super.key,
    this.height,
    this.width,
    required this.aspectRatio,
    required this.builder,
  });

  final double? width;
  final double? height;
  final double aspectRatio;
  final Widget Function(BuildContext context, BoxConstraints constraints)
      builder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.buildAspectRatio(
            aspectRatio: aspectRatio,
            child: builder(context, constraints),
          );
        },
      ),
    );
  }
}
