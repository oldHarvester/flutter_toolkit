import 'package:flutter_toolkit/core/models/operation_result.dart';

extension FutureExtension<T> on Future<T> {
  Future<OperationResult<T>> safeExecute() async {
    try {
      final result = await this;
      return OperationResult.success(result);
    } catch (e, stk) {
      return OperationResult.failed(error: e, stackTrace: stk);
    }
  }
}
