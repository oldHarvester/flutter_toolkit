import 'dart:async';

import 'package:flutter/material.dart';

class SafeExecutorLink {
  const SafeExecutorLink._({required Completer<bool> completer})
      : _completer = completer;

  final Completer<bool> _completer;

  void cancel() {
    if (!_completer.isCompleted) {
      _completer.complete(false);
    }
  }

  void _completeSuccess() {
    if (!_completer.isCompleted) {
      _completer.complete(true);
    }
  }

  void _completeError(Object error, StackTrace stackTrace) {
    if (!_completer.isCompleted) {
      _completer.completeError(error, stackTrace);
    }
  }

  void _completeFailed() {
    if (!_completer.isCompleted) {
      _completer.complete(false);
    }
  }
}

enum SafeExecutorType {
  zeroDelayed,
  postFrameCallback,
  microtask,
}

class SafeExecutor {
  Completer<bool>? _tempCompleter;

  Future<bool> perform(
    VoidCallback action, {
    SafeExecutorType type = SafeExecutorType.postFrameCallback,
    void Function(SafeExecutorLink link)? linkHandler,
  }) {
    final completer = Completer<bool>();
    _tempCompleter = completer;
    final link = SafeExecutorLink._(
      completer: completer,
    );
    linkHandler?.call(link);
    void onAction() {
      try {
        if (completer == _tempCompleter && !completer.isCompleted) {
          action();
          link._completeSuccess();
        } else {
          link._completeFailed();
        }
      } catch (e, stk) {
        link._completeError(e, stk);
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
