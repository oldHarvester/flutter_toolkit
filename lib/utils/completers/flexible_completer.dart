import 'dart:async';

import 'package:flutter_toolkit/utils/executors/throttle_executor.dart';

enum FlexibleCompleterExceptionType {
  timeout,
  cancelled,
  ;

  const FlexibleCompleterExceptionType();
}

class FlexibleCompleterException implements Exception {
  const FlexibleCompleterException(this.type);
  final FlexibleCompleterExceptionType type;

  @override
  String toString() {
    return '$runtimeType - $type';
  }
}

class FlexibleCompleter<T> {
  FlexibleCompleter({
    this.onCancel,
    this.timeoutDuration,
    this.onTimeout,
    bool synchronous = true,
    this.onComplete,
    this.onCompleteWithError,
  }) {
    _completer = synchronous ? Completer.sync() : Completer();
    _completer.future.ignore();
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
          onTimeout?.call();
        },
      );
    }
  }

  final void Function()? onCancel;

  final void Function()? onTimeout;

  final void Function(T? value)? onComplete;

  final void Function(Object error, StackTrace stackTrace)? onCompleteWithError;

  final Duration? timeoutDuration;

  late final Completer<T> _completer;

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

  T? _value;

  Object? _error;

  StackTrace? _stackTrace;

  Object? get error => _error;

  StackTrace? get stackTrace => _stackTrace;

  Future<T> get future => _completer.future;

  T? get value => _value;

  bool cancel([T? value]) {
    if (isCompleted) {
      return false;
    }
    _isCancelled = true;
    cancelTimeout();
    onCancel?.call();
    if (value != null) {
      complete(value);
    } else {
      completeError(
        FlexibleCompleterException(
          FlexibleCompleterExceptionType.cancelled,
        ),
      );
    }
    return true;
  }

  bool cancelTimeout() {
    return _timeoutExecutor.stop();
  }

  bool complete([T? value]) {
    if (isCompleted) {
      return false;
    }
    try {
      cancelTimeout();
      _completer.complete(value);
      _isCompleted = true;
      _value = value;
      onComplete?.call(value);
    } catch (e, stk) {
      _completer.completeError(e, stk);
      rethrow;
    }
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
