import 'dart:async';

import 'package:flutter_toolkit/core/models/operation_result.dart';
import 'package:flutter_toolkit/utils/completers/flexible_completer.dart';

typedef AutoRestartExecutorHandler<T> = FutureOr<T> Function();

typedef AutoRestartExecutorResultHandler<T> = void Function(
    OperationResult<T> result);

class AutoRestartExecutor<T> {
  AutoRestartExecutor({
    required this.handler,
    this.onResult,
    this.autoStart = true,
    this.restartDuration = const Duration(seconds: 5),
  }) {
    if (autoStart) {
      startExecute();
    }
  }

  final AutoRestartExecutorHandler<T> handler;

  final AutoRestartExecutorResultHandler<T>? onResult;

  final Duration restartDuration;

  final bool autoStart;

  final FlexibleCompleter<T> _completer = FlexibleCompleter();

  Future<T?> get future {
    return _completer.future;
  }

  bool _disposed = false;

  bool _started = false;

  bool get started => _started;

  bool get disposed => _disposed;

  void dispose() {
    _disposed = true;
    _completer.cancel(null);
  }

  Future<T?> startExecute() async {
    if (started) return null;
    _started = true;
    return _executor();
  }

  Future<T?> _executor() async {
    if (disposed) return null;
    try {
      final result = await handler();
      if (disposed) return null;
      onResult?.call(OperationResult.success(result));
      _completer.complete(result);
      return result;
    } catch (e, stk) {
      if (disposed) return null;
      onResult?.call(OperationResult.failed(error: e, stackTrace: stk));
      await Future.delayed(restartDuration);
      return _executor();
    }
  }
}
