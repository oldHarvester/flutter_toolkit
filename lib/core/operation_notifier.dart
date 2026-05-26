import 'dart:async';

import 'package:flutter_toolkit/core/extended_value_notifier.dart';
import 'package:flutter_toolkit/core/models/operation_progress.dart';

class OperationNotifier<T> extends ExtendedValueNotifier<OperationProgress<T>> {
  OperationNotifier() : super(OperationProgress.idle());

  FutureOr<T> execute({
    required FutureOr<T> Function() operation,
  }) async {
    try {
      setValue(OperationProgress<T>.processing());
      final result = await operation();
      setValue(OperationProgress<T>.success(result));
      return result;
    } catch (e, stk) {
      setValue(
        OperationProgress<T>.failed(
          error: e,
          stackTrace: stk,
        ),
      );
      rethrow;
    }
  }
}
