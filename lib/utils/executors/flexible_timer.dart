import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class TickInfo with EquatableMixin {
  const TickInfo({
    required this.spend,
    required this.total,
    required this.didTick,
    required this.tick,
  });

  const TickInfo.zero()
      : spend = Duration.zero,
        total = Duration.zero,
        tick = Duration.zero,
        didTick = Duration.zero;

  final Duration total;
  final Duration spend;
  final Duration didTick;
  final Duration tick;

  TickInfo copyWith({
    Duration? spend,
    Duration? total,
    Duration? tick,
    Duration? didTick,
  }) {
    return TickInfo(
      didTick: didTick ?? this.didTick,
      spend: spend ?? this.spend,
      tick: tick ?? this.tick,
      total: total ?? this.total,
    );
  }

  Duration get left => total - spend;

  @override
  String toString() {
    return 'max: ${total.hhmmss()}, done: ${left.hhmmss()}, %: $progress';
  }

  double get progress => (spend / total).clamp(0.0, 1.0);

  bool get complete => progress == 1;

  @override
  List<Object?> get props => [total, spend, left, didTick, tick];
}

class FlexibleTimer {
  FlexibleTimer({
    this.debug = kDebugMode,
    this.debugLabel,
  });

  final ThrottleExecutor executor = ThrottleExecutor();
  final bool debug;
  final String? debugLabel;
  late final CustomLogger _logger = CustomLogger(
    owner: debugLabel ?? runtimeType.toString(),
  );

  TickInfo _tempTick = TickInfo.zero();

  Duration get _spendDuration => _tempTick.spend;

  void start({
    Duration? from,
    required Duration totalDuration,
    required Duration tickDuration,
    required void Function(TickInfo info)? onTick,
    VoidCallback? onComplete,
  }) {
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
      didTick: tickDuration,
    );

    void startTick({Duration? overrideTick}) {
      if (_tempTick.complete) return;
      final resultTick = overrideTick ?? tickDuration;
      executor.execute(
        duration: resultTick,
        onAction: () {
          _tempTick = _tempTick.copyWith(
            spend: clamp(_tempTick.spend + resultTick),
            didTick: resultTick,
          );
          final leftDuration = totalDuration - _spendDuration;
          final nextTickDuration =
              leftDuration < tickDuration ? leftDuration : tickDuration;
          _logger.log(_tempTick.toString());
          onTick?.call(_tempTick);
          if (!_tempTick.complete) {
            startTick(
              overrideTick: nextTickDuration,
            );
          } else {
            onComplete?.call();
          }
        },
      );
    }

    startTick();
  }

  void stop() {
    executor.stop();
  }
}
