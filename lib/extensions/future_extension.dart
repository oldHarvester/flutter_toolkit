import 'package:flutter_toolkit/core/models/operation_result.dart';

extension FutureExtension<T> on Future<T> {
  Future<OperationResult<T>> safeExecute() async {
    final stopWatch = Stopwatch()..start();
    try {
      final result = await this;
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
}
