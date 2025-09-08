import 'dart:async';
import 'dart:ui';

class ThrottleExecutor<T> {
  Timer? _timer;
  T? _arg;

  void _start({
    T? arg,
    Duration duration = const Duration(milliseconds: 400),
    required VoidCallback onAction,
  }) {
    _timer ??= Timer(
      duration,
      () {
        stop();
        onAction();
      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
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
