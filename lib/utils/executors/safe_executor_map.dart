import 'dart:ui';

import 'package:flutter_toolkit/flutter_toolkit.dart';

final class SafeExecutorMap<T> {
  final Map<T, SafeExecutor> _executors = {};

  SafeExecutor executorBy(T item) {
    final executor = _executors[item];
    if (executor == null) {
      final newExecutor = SafeExecutor();
      _executors[item] = newExecutor;
      return newExecutor;
    } else {
      return executor;
    }
  }

  void cancel(T item) {
    executorBy(item).cancel();
  }

  void cancelAll() {
    for (final entry in _executors.entries) {
      entry.value.cancel();
    }
  }

  void clear() {
    cancelAll();
    _executors.clear();
  }

  void execute(
    T item, {
    required VoidCallback action,
    bool cancelPrevious = SafeExecutor.defaultCancelPrevious,
    SafeExecutorType type = SafeExecutor.defaultType,
  }) {
    executorBy(item).perform(
      action,
      cancelPrevious: cancelPrevious,
      type: type,
    );
  }
}
