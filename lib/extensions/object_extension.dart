import 'package:flutter_toolkit/flutter_toolkit.dart';

extension NullableObjectExtension<T extends Object?> on T {
  T? ifChanged(T? obj) {
    return this != obj ? this : null;
  }

  Cast? castOrNull<Cast>() {
    if (this is Cast) {
      return this as Cast;
    } else {
      return null;
    }
  }
}

extension ObjectExtension<Z extends Object> on Z {
  OperationResult<Z> safeExecute() {
    final stopWatch = Stopwatch()..start();
    try {
      final result = this;
      stopWatch.stop();
      return OperationResult.success(
        result,
        elapsedTime: stopWatch.elapsed,
      );
    } catch (e, stk) {
      stopWatch.stop();
      return OperationResult.failed(
        error: e,
        stackTrace: stk,
        elapsedTime: stopWatch.elapsed,
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
