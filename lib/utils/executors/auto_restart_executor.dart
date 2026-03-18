import 'dart:async';

import 'package:flutter_toolkit/utils/completers/flexible_completer.dart';

typedef AutoRestartExecutorHandler<T> = FutureOr<T> Function();

typedef AutoRestartExecutorSuccessHandler<T> = void Function(T result);

/// Return false if u want to throw error
typedef AutoRestartExecutorErrorHandler = FutureOr<bool?> Function(
  int retries,
  Object error,
  StackTrace stackTrace,
);

class AutoRestartExecutor<T> {
  AutoRestartExecutor({
    required this.handler,
    this.autoStart = true,
    this.onSuccess,
    this.onError,
    this.maxRetries,
    this.timeOutDuration,
    this.restartDuration = const Duration(seconds: 5),
  }) {
    if (autoStart) {
      start();
    }
  }

  final AutoRestartExecutorHandler<T> handler;

  final AutoRestartExecutorSuccessHandler<T>? onSuccess;

  final AutoRestartExecutorErrorHandler? onError;

  final Duration restartDuration;

  final Duration? timeOutDuration;

  final bool autoStart;

  final int? maxRetries;

  final FlexibleCompleter<T> _completer = FlexibleCompleter();

  FlexibleCompleter<void>? _timerCompleter;

  Timer? _timer;

  Timer? _timeOutTimer;

  Future<T> get future {
    return _completer.future;
  }

  Future<T?> get futureOrNull async {
    try {
      return await future;
    } catch (e) {
      return null;
    }
  }

  bool _cancelled = false;

  bool _started = false;

  int _retries = -1;

  int get retries => _retries;

  bool get started => _started;

  bool get cancelled => _cancelled;

  bool get retriesLimitExceed {
    final max = maxRetries;
    if (max == null) return false;
    return _retries >= max;
  }

  void cancel() {
    _cancelled = true;
    _cancelTimer();
    _completer.cancel();
    cancelTimeout();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timerCompleter?.complete();
  }

  Future<void> _wait(Duration duration) {
    _cancelTimer();
    final completer = FlexibleCompleter();
    _timerCompleter = completer;
    _timer = Timer(
      duration,
      () {
        completer.complete();
      },
    );
    return completer.future;
  }

  Future<T> start() async {
    final timeOutDuration = this.timeOutDuration;
    if (!started) {
      if (timeOutDuration != null) {
        _timeOutTimer ??= Timer(
          timeOutDuration,
          () {
            cancel();
          },
        );
      }
      _executor();
    }
    return future;
  }

  void cancelTimeout() {
    _timeOutTimer?.cancel();
    _timeOutTimer = null;
  }

  void _completeWithError(Object error, StackTrace stackTrace) {
    _completer.completeError(error, stackTrace);
    cancel();
  }

  Future<void> _executor() async {
    if (cancelled) return;
    _started = true;
    _retries++;
    try {
      final result = await handler();
      if (cancelled) return;
      _completer.complete(result);
      onSuccess?.call(result);
    } catch (e, stk) {
      if (cancelled) return;
      final errorResult = (await onError?.call(retries, e, stk)) ?? true;
      if (!errorResult) {
        _completeWithError(e, stk);
        return;
      }
      if (retriesLimitExceed) {
        _completeWithError(e, stk);
        return;
      }
      await _wait(restartDuration);
      return _executor();
    }
  }
}
