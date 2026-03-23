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

  Z copyIfCollection() {
    final obj = this;
    if (obj is Map) {
      return {...obj} as Z;
    } else if (obj is List) {
      return [...obj] as Z;
    } else if (obj is Set) {
      return {...obj} as Z;
    } else if (obj is Iterable) {
      return obj.toList() as Z;
    } else {
      return obj;
    }
  }
}
