import 'dart:async';

import 'package:flutter_toolkit/flutter_toolkit.dart';

typedef InfiniteTaskAction<T> = FutureOr<T> Function();

class InfiniteTaskExecutor<T> {
  InfiniteTaskExecutor({
    required this.action,
    this.waitDuration = Duration.zero,
    this.interval = const Duration(seconds: 1),
    this.onResult,
    this.onError,
    this.onSuccess,
    this.autoStart = true,
  }) {
    if (autoStart) {
      start();
    }
  }

  final bool autoStart;
  final Duration interval;
  final Duration waitDuration;
  final InfiniteTaskAction<T> action;
  final void Function(OperationResult<T> result)? onResult;
  final void Function(T value)? onSuccess;
  final void Function(Object error, StackTrace stackTrace)? onError;

  bool _disposed = false;

  bool _started = false;

  Duration _elapsedTime = Duration.zero;

  Duration get elapsedTime => _elapsedTime;

  bool get started => _started;

  bool get disposed => _disposed;

  Timer? _timer;

  Future<OperationResult<T>> _execute() async {
    final result = await action().safeExecute();
    onResult?.call(result);
    result.when(
      onSuccess: (result) {
        onSuccess?.call(result);
      },
      onError: (error, stackTrace) {
        onError?.call(error, stackTrace);
      },
    );
    if (!_disposed) {
      _elapsedTime += result.elapsedTime;
    }
    return result;
  }

  void start() {
    if (_started || disposed) {
      return;
    }
    _started = true;
    _elapsedTime = Duration.zero;
    _timer ??= Timer(
      waitDuration,
      () async {
        _startInfinite();
      },
    );
  }

  Future<void> _startInfinite() async {
    if (disposed) return;
    await _execute();
    if (disposed) return;
    _timer = Timer(
      interval,
      () {
        _elapsedTime += interval;
        _startInfinite();
      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _disposed = true;
    stop();
  }
}
