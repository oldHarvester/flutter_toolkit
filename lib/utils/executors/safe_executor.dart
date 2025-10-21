import 'dart:async';

import 'package:flutter/material.dart';

import '../completers/flexible_completer.dart';

enum SafeExecutorType {
  zeroDelayed,
  postFrameCallback,
  microtask,
}

class SafeExecutor {
  static const defaultCancelPrevious = true;

  static const defaultType = SafeExecutorType.postFrameCallback;

  FlexibleCompleter<bool>? _tempCompleter;

  void cancel() {
    _tempCompleter?.cancel(false);
  }

  Future<bool> perform(
    VoidCallback action, {
    bool cancelPrevious = defaultCancelPrevious,
    SafeExecutorType type = defaultType,
  }) {
    if (cancelPrevious) {
      cancel();
    }
    final completer = FlexibleCompleter<bool>();
    _tempCompleter = completer;

    void onAction() {
      try {
        if (completer == _tempCompleter && !completer.isCompleted) {
          action();
          completer.complete(true);
        } else {
          completer.complete(false);
        }
      } catch (e, _) {
        completer.completeError(e);
      }
    }

    switch (type) {
      case SafeExecutorType.microtask:
        Future.microtask(onAction);
        break;
      case SafeExecutorType.postFrameCallback:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => onAction(),
        );
        break;
      case SafeExecutorType.zeroDelayed:
        Future.delayed(
          Duration.zero,
          onAction,
        );
        break;
    }
    return completer.future;
  }
}
