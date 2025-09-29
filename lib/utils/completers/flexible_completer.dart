import 'dart:async';

class FlexibleCompleter<T> {
  FlexibleCompleter({this.onCancel});

  final void Function()? onCancel;

  final Completer<T> _compeleter = Completer<T>();

  bool _isCancelled = false;

  bool _isCompleted = false;

  bool _isCompetedWithError = false;

  bool get isCancelled => _isCancelled;

  bool get isCompleted => _isCompleted;

  bool get isCompetedWithError => _isCompetedWithError;

  bool get isSuccessfullyCompleted =>
      !isCancelled && !isCompetedWithError && isCompleted;

  Object? _error;

  StackTrace? _stackTrace;

  Object? get error => _error;

  StackTrace? get stackTrace => _stackTrace;

  Future<T> get future => _compeleter.future;

  bool cancel([FutureOr<T>? value]) {
    if (isCompleted) {
      return false;
    }
    onCancel?.call();
    _compeleter.complete(value);
    _isCancelled = true;
    _isCompleted = true;
    return true;
  }

  bool complete([FutureOr<T>? value]) {
    if (isCompleted) {
      return false;
    }
    _compeleter.complete(value);
    _isCompleted = true;
    return true;
  }

  bool completeError(Object error, [StackTrace? stackTrace]) {
    if (isCompleted) {
      return false;
    }
    _compeleter.completeError(error, stackTrace);
    _isCompleted = true;
    _isCompetedWithError = true;
    _error = error;
    _stackTrace = stackTrace;
    return true;
  }

  bool canPerformAction(FlexibleCompleter? completer) {
    return completer == this && !this.isCancelled && !this.isCompleted;
  }
}
