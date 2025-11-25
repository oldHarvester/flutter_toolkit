import 'dart:async';

import 'package:flutter_toolkit/utils/executors/throttle_executor.dart';

enum FlexibleCompleterExceptionType {
  timeout,
  ;

  const FlexibleCompleterExceptionType();
}

class FlexibleCompleterException implements Exception {
  const FlexibleCompleterException(this.type);
  final FlexibleCompleterExceptionType type;
}

class FlexibleCompleter<T> {
  FlexibleCompleter({
    this.onCancel,
    this.timeoutDuration,
  }) {
    if (timeoutDuration != null) {
      _timeoutExecutor.execute(
        duration: timeoutDuration!,
        onAction: () {
          _isTimeout = true;
          completeError(
            FlexibleCompleterException(
              FlexibleCompleterExceptionType.timeout,
            ),
          );
        },
      );
    }
  }

  final void Function()? onCancel;

  final Duration? timeoutDuration;

  final Completer<T> _completer = Completer<T>();

  final ThrottleExecutor _timeoutExecutor = ThrottleExecutor();

  bool _isCancelled = false;

  bool _isCompleted = false;

  bool _isCompetedWithError = false;

  bool _isTimeout = false;

  bool get isTimeout => _isTimeout;

  bool get isCancelled => _isCancelled;

  bool get isCompleted => _isCompleted;

  bool get isCompetedWithError => _isCompetedWithError;

  bool get isSuccessfullyCompleted =>
      !isCancelled && !isCompetedWithError && isCompleted;

  Object? _error;

  StackTrace? _stackTrace;

  Object? get error => _error;

  StackTrace? get stackTrace => _stackTrace;

  Future<T> get future => _completer.future;

  bool cancel([FutureOr<T>? value]) {
    if (isCompleted) {
      return false;
    }
    cancelTimeout();
    onCancel?.call();
    _completer.complete(value);
    _isCancelled = true;
    _isCompleted = true;
    return true;
  }

  bool cancelTimeout() {
    return _timeoutExecutor.stop();
  }

  bool complete([FutureOr<T>? value]) {
    if (isCompleted) {
      return false;
    }
    cancelTimeout();
    _completer.complete(value);
    _isCompleted = true;
    return true;
  }

  bool completeError(Object error, [StackTrace? stackTrace]) {
    if (isCompleted) {
      return false;
    }
    cancelTimeout();
    _completer.completeError(error, stackTrace);
    _isCompleted = true;
    _isCompetedWithError = true;
    _error = error;
    _stackTrace = stackTrace;
    return true;
  }

  bool canPerformAction(FlexibleCompleter? completer) {
    return completer == this && !this.isCancelled && !this.isCompleted;
  }
}
