import 'dart:async';

import 'package:flutter_toolkit/flutter_toolkit.dart';

typedef Action<T> = FutureOr<T> Function();

class InfiniteTaskExecutor<T> {
  InfiniteTaskExecutor({
    this.duration = const Duration(seconds: 1),
    Action<T>? action,
  }) : _action = action;

  final Duration duration;
  final ThrottleExecutor _executor = ThrottleExecutor();

  Action<T>? _action;

  bool _paused = true;

  bool _disposed = false;

  bool get paused => _paused;

  bool get disposed => _disposed;

  void pause() {
    if (_disposed) {
      return;
    }
    _paused = true;
    _executor.stop();
  }

  void setAction({Action<T>? action}) {
    if (_disposed) {
      return;
    }
    _action = action;
  }

  void play({Action<T>? action}) {
    if (_disposed) {
      return;
    }
    setAction(action: action);
    _paused = false;
    _execute();
  }

  void toggle({Action<T>? action}) {
    if (_disposed) {
      return;
    }
    setAction(action: action);
    if (_paused) {
      play(action: action);
    } else {
      pause();
    }
  }

  void _execute() {
    final action = _action;
    _paused = false;
    _executor.execute(
      duration: duration,
      onAction: () async {
        await action?.call();
        if (!_paused || _disposed) {
          _execute();
        }
      },
    );
  }

  void dispose() {
    _disposed = true;
    _paused = true;
    _executor.stop();
  }
}
