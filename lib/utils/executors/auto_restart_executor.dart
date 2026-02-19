import 'dart:async';

import 'package:flutter_toolkit/core/models/operation_result.dart';

typedef AutoRestartExecutorHandler<T> = FutureOr<T> Function();

typedef AutoRestartExecutorResultHandler<T> = void Function(OperationResult<T>);

class AutoRestartExecutor<T> {
  AutoRestartExecutor({
    required this.handler,
    required this.onResult,
    this.restartDuration = const Duration(seconds: 5),
  }) {
    _startHandler();
  }

  final AutoRestartExecutorHandler<T> handler;
  final AutoRestartExecutorResultHandler<T> onResult;
  final Duration restartDuration;

  bool _disposed = false;

  bool get disposed => _disposed;

  void dispose() {
    _disposed = true;
  }

  Future<void> _startHandler() async {
    if (disposed) return;
    try {
      final result = await handler();
      if (disposed) return;
      onResult(OperationResult.success(result));
    } catch (e, stk) {
      if (disposed) return;
      onResult(OperationResult.failed(error: e, stackTrace: stk));
      await Future.delayed(restartDuration);
      _startHandler();
    }
  }
}
