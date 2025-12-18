import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

typedef Action<T> = FutureOr<T> Function();

class InfiniteTaskExecutor<T> {
  InfiniteTaskExecutor({
    this.duration = const Duration(seconds: 1),
    Action<T>? action,
    this.onResult,
  }) : _action = action;

  final Duration duration;
  final ValueChanged<OperationResult<T>>? onResult;
  final ThrottleExecutor _executor = ThrottleExecutor();

  Action<T>? _action;

  bool _paused = true;

  bool _disabled = false;

  bool get paused => _paused;

  bool get active => !paused;

  bool get disabled => _disabled;

  bool stop() {
    if (disabled) {
      return false;
    }
    _paused = true;
    _executor.stop();
    return true;
  }

  bool setAction({required Action<T> action}) {
    if (disabled) {
      return false;
    }
    _action = action;
    return true;
  }

  bool execute({Action<T>? action}) {
    if (disabled) {
      return false;
    }
    if (action != null) {
      setAction(action: action);
    }
    return _execute();
  }

  bool toggle({Action<T>? action}) {
    if (disabled) {
      return false;
    }
    if (action != null) {
      setAction(action: action);
    }
    if (_paused) {
      return execute(action: action);
    } else {
      return stop();
    }
  }

  bool _execute() {
    if (_action == null) {
      return false;
    }
    _paused = false;
    _executor.execute(
      duration: duration,
      onAction: () async {
        final operationResult = await _action?.call().safeExecute();
        if (!active && !disabled) {
          if (operationResult != null) {
            onResult?.call(operationResult);
          }
          _execute();
        }
      },
    );
    return true;
  }

  void disable() {
    _disabled = true;
    _paused = true;
    _executor.stop();
  }
}
