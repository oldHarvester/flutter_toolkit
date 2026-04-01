import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

enum ThrottleCollectorType {
  /// Копит данные в течении одного фрейма
  frame,

  /// Копит данные в течении указанного периода
  throttle,

  /// Копит данные пока идут вызовы с указанным периодом

  debouncer,
}

typedef ThrottleCollectionHandler<T> = void Function(List<T> data);

typedef ThrottleCollectionEqualityHandler<T> = bool Function(T a, T b);

/// Will clear itself automatically depending on `ThrottleCollectorType`
class ThrottleCollection<T> {
  ThrottleCollection({
    bool enabled = true,
    this.type = ThrottleCollectorType.debouncer,
    this.unique = false,
    required this.handler,
    this.equalityHandler,
    this.throttleDuration = const Duration(milliseconds: 300),
  }) : _enabled = enabled;

  final ThrottleCollectorType type;

  final ThrottleCollectionHandler<T> handler;

  final ThrottleCollectionEqualityHandler<T>? equalityHandler;

  final Duration throttleDuration;

  final bool unique;

  final List<T> _collection = [];

  bool _enabled;

  bool _disposed = false;

  bool get enabled => !_disposed && _enabled;

  FlexibleCompleter<void>? _frameCompleter;

  void enable() {
    _enabled = true;
  }

  void disable() {
    _enabled = false;
    _cancelFrame();
  }

  void dispose() {
    _disposed = true;
    disable();
  }

  void _cancelFrame() {
    _frameCompleter?.cancel();
    _frameCompleter = null;
    _collection.clear();
  }

  void _onComplete() {
    final collection = [..._collection];
    _collection.clear();
    handler(collection);
  }

  bool _contains(T object) {
    final handler = this.equalityHandler ??
        (T a, T b) {
          return FlexibleEquality().equals(a, b);
        };
    final element = _collection.firstWhereOrNull(
      (element) {
        return handler(object, element);
      },
    );
    return element != null;
  }

  void add(T object) {
    if (!enabled) return;
    final oldCompleter = _frameCompleter;
    switch (type) {
      case ThrottleCollectorType.frame:
        if (oldCompleter == null || oldCompleter.isCompleted) {
          final completer = FlexibleCompleter();
          _frameCompleter = completer;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (completer.canPerformAction(_frameCompleter)) {
                completer.complete();
                _onComplete();
              }
            },
          );
        }
        break;
      case ThrottleCollectorType.debouncer:
        _frameCompleter?.cancel();
        final completer = FlexibleCompleter();
        _frameCompleter = completer;
        Future.delayed(
          throttleDuration,
          () {
            if (completer.canPerformAction(_frameCompleter)) {
              completer.complete();
              _onComplete();
            }
          },
        );
        break;
      case ThrottleCollectorType.throttle:
        if (oldCompleter == null || oldCompleter.isCompleted) {
          final completer = FlexibleCompleter();
          _frameCompleter = completer;
          Future.delayed(
            throttleDuration,
            () {
              if (completer.canPerformAction(_frameCompleter)) {
                completer.complete();
                _onComplete();
              }
            },
          );
        }
    }
    if (unique && _contains(object)) {
      return;
    }
    _collection.add(object);
  }
}
