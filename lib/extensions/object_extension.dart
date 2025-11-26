import 'package:flutter_toolkit/flutter_toolkit.dart';

extension ObjectExtension<Z extends Object> on Z {
  T? castOrNull<T>() {
    if (this is T) {
      return this as T;
    } else {
      return null;
    }
  }

  OperationResult<Z> safeExecute() {
    try {
      return OperationResult.success(this);
    } catch (e, stk) {
      return OperationResult.failed(
        error: e,
        stackTrace: stk,
      );
    }
  }
}
