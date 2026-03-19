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

typedef AutoRestartExecutorOnRetryStarted = void Function(
  int retry,
  Object error,
  StackTrace stackTrace,
);

typedef ErrorStacktrace = ({Object error, StackTrace stackTrace});

class AutoRestartExecutor<T> {
  AutoRestartExecutor({
    required this.handler,
    this.autoStart = true,
    this.onSuccess,
    this.onError,
    this.maxRetries,
    this.onRetryStarted,
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

  final AutoRestartExecutorOnRetryStarted? onRetryStarted;

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

  bool _timeoutCancelled = false;

  ErrorStacktrace? _errorStacktrace;

  bool get retriesLimitExceed {
    final max = maxRetries;
    if (max == null) return false;
    return _retries >= max;
  }

  void cancel([ErrorStacktrace? errorStackTrace]) {
    final errStk = errorStackTrace ??
        _errorStacktrace ??
        (
          error: Exception('Timeout'),
          stackTrace: StackTrace.current,
        );
    _cancelled = true;
    _cancelTimer();
    _completer.completeError(errStk.error, errStk.stackTrace);
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

  void startTimeoutTimer() {
    if (_timeoutCancelled) return;
    final timeOutDuration = this.timeOutDuration;
    if (timeOutDuration != null) {
      _timeOutTimer ??= Timer(
        timeOutDuration,
        () {
          cancel();
        },
      );
    }
  }

  Future<T> start() async {
    if (!_started) {
      _executor();
    }
    return future;
  }

  void cancelTimeout() {
    _timeoutCancelled = true;
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
    final lastErrStk = _errorStacktrace;
    if (lastErrStk != null) {
      onRetryStarted?.call(retries, lastErrStk.error, lastErrStk.stackTrace);
    }
    if (retries > 0) {
      startTimeoutTimer();
    }
    try {
      final result = await handler();
      if (cancelled) return;
      _completer.complete(result);
      onSuccess?.call(result);
    } catch (e, stk) {
      _errorStacktrace = (error: e, stackTrace: stk);
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
