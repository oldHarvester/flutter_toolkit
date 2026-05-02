import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class TickInfo with EquatableMixin {
  const TickInfo({
    required this.spend,
    required this.total,
    required this.lastTick,
    required this.tick,
  });

  const TickInfo.zero()
      : spend = Duration.zero,
        total = Duration.zero,
        tick = Duration.zero,
        lastTick = Duration.zero;

  final Duration total;
  final Duration spend;
  final Duration lastTick;
  final Duration tick;

  TickInfo copyWith({
    Duration? spend,
    Duration? total,
    Duration? tick,
    Duration? lastTick,
  }) {
    return TickInfo(
      lastTick: lastTick ?? this.lastTick,
      spend: spend ?? this.spend,
      tick: tick ?? this.tick,
      total: total ?? this.total,
    );
  }

  Duration get left => total - spend;

  @override
  String toString() {
    return 'max: ${total.hhmmss()}, done: ${spend.hhmmss()}, left: ${left.hhmmss()} %: $progress';
  }

  /// From 0 to 1
  double get progress =>
      total == Duration.zero ? 1 : (spend / total).clamp(0.0, 1.0);

  bool get complete => progress >= 1.0;

  @override
  List<Object?> get props => [total, spend, left, lastTick, tick];
}

class FlexibleTimer {
  FlexibleTimer({
    this.debug = false,
    this.debugLabel,
  });

  final ThrottleExecutor _executor = ThrottleExecutor();
  final bool debug;
  final String? debugLabel;
  late final CustomLogger _logger = CustomLogger(
    owner: debugLabel ?? runtimeType.toString(),
    showLogs: debug,
  );
  FlexibleCompleter<bool>? _completer;

  TickInfo _tempTick = TickInfo.zero();

  Duration get _spendDuration => _tempTick.spend;

  Duration get spendDuration => _spendDuration;

  Future<bool> oneTickStart(Duration tick, {VoidCallback? onComplete}) {
    return start(
      totalDuration: tick,
      tickDuration: tick,
      onTick: (info) {},
      onComplete: onComplete,
    );
  }

  Future<bool> start({
    Duration? from,
    required Duration totalDuration,
    required Duration tickDuration,
    required void Function(TickInfo info)? onTick,
    VoidCallback? onComplete,
  }) async {
    stop();
    final completer = FlexibleCompleter<bool>();
    _completer = completer;

    Duration clamp(Duration duration) {
      return duration.clamp(
        min: Duration.zero,
        max: totalDuration,
      );
    }

    tickDuration = clamp(tickDuration);
    final initialSpend = clamp(from ?? Duration.zero);
    _tempTick = _tempTick.copyWith(
      spend: initialSpend,
      total: totalDuration,
      tick: tickDuration,
      lastTick: tickDuration,
    );

    void startTick({Duration? overrideTick}) {
      final resultTick = overrideTick ?? tickDuration;
      _executor.execute(
        duration: resultTick,
        onAction: () {
          if (_completer != completer || completer.isCompleted) return;
          _tempTick = _tempTick.copyWith(
            spend: clamp(_tempTick.spend + resultTick),
            lastTick: resultTick,
          );
          final leftDuration = totalDuration - _spendDuration;
          final nextTickDuration =
              leftDuration < tickDuration ? leftDuration : tickDuration;
          _logger.log(_tempTick.toString());
          onTick?.call(_tempTick);
          if (!_tempTick.complete && completer.canPerformAction(_completer)) {
            startTick(overrideTick: nextTickDuration);
          } else {
            _completeFuture(true);
            onComplete?.call();
          }
        },
      );
    }

    startTick();

    return completer.future;
  }

  void _completeFuture(bool success) {
    _completer?.complete(success);
  }

  void stop() {
    _completeFuture(false);
    _executor.stop();
    _tempTick = TickInfo.zero();
  }
}
