import 'package:flutter/material.dart';

import 'throttling_controller.dart';

class ThrottlingBuilder<T> extends ValueListenableBuilder<T> {
  ThrottlingBuilder({
    super.child,
    super.key,
    required ThrottlingController<T> controller,
    required Widget Function(
            BuildContext context, T value, T? pending, Widget? child)
        builder,
  }) : super(
          valueListenable: controller,
          builder: (context, value, child) {
            return builder(
              context,
              value,
              controller.pendingValue,
              child,
            );
          },
        );
}
