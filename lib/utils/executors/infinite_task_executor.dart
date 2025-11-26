import 'dart:async';

import 'package:flutter_toolkit/flutter_toolkit.dart';

class InfiniteTaskExecutor<T> {
  InfiniteTaskExecutor({
    this.duration = const Duration(seconds: 1),
  });

  final Duration duration;
  final ThrottleExecutor _executor = ThrottleExecutor();

  FutureOr<T> Function()? _foo;

  bool _paused = true;

  bool _disposed = false;

  bool get paused => _paused;

  bool get disposed => _disposed;

  void pause() {
    _paused = true;
    _executor.stop();
  }

  void play() {
    _paused = false;
    final foo = _foo;
    if (foo != null) {
      execute(foo);
    }
  }

  void toggle() {
    if (_paused) {
      play();
    } else {
      pause();
    }
  }

  void execute(FutureOr<T> Function() foo) {
    _foo = foo;
    _paused = false;
    _executor.execute(
      duration: duration,
      onAction: () async {
        await foo();
        if (!_paused || _disposed) {
          execute(foo);
        }
      },
    );
  }

  void dispose() {
    _disposed = true;
    _executor.stop();
  }
}
