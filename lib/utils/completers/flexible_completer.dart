import 'dart:async';

class FlexibleCompleter<T> {
  final Completer<T> _compeleter = Completer<T>();

  bool _isCancelled = false;

  bool _isCompleted = false;

  bool _isCompeteWithError = false;

  bool get isCancelled => _isCancelled;

  bool get isCompleted => _isCompleted;

  bool get isCompeteWithError => _isCompeteWithError;

  Object? _error;

  StackTrace? _stackTrace;

  Object? get error => _error;

  StackTrace? get stackTrace => _stackTrace;

  bool cancel() {
    if (isCompleted) {
      return false;
    }

    _compeleter.complete();
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
    _isCompeteWithError = true;
    _error = error;
    _stackTrace = stackTrace;
    return true;
  }
}
