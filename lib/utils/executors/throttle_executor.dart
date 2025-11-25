import 'dart:async';
import 'dart:ui';

class ThrottleExecutor<T> {
  Timer? _timer;
  T? _arg;

  bool get isActive => _timer != null && _timer!.isActive;

  void _start({
    T? arg,
    Duration duration = const Duration(milliseconds: 400),
    required VoidCallback onAction,
  }) {
    void callback() {
      stop();
      onAction();
    }

    if (_timer == null) {
      if (duration == Duration.zero) {
        callback();
      } else {
        _timer = Timer(
          duration,
          callback,
        );
      }
    }
  }

  bool stop() {
    final timer = _timer;
    if (timer != null && timer.isActive) {
      timer.cancel();
      _timer = null;
      return true;
    } else {
      return false;
    }
  }

  void execute({
    T? arg,
    Duration duration = const Duration(milliseconds: 400),
    required VoidCallback onAction,
    void Function(T? arg)? onSkipped,
  }) {
    final oldArg = _arg;
    _arg = arg;
    if (oldArg != arg || arg == null) {
      stop();
      _start(arg: arg, onAction: onAction, duration: duration);
    } else {
      onSkipped?.call(arg);
    }
  }
}
