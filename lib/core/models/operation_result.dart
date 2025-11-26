extension OperationResultExtension<T> on OperationResult<T> {
  T? get result {
    return when(
      onSuccess: (result) {
        return result;
      },
      onError: (error, stackTrace) {
        return null;
      },
    );
  }

  Object? get error {
    return when(
      onSuccess: (result) {
        return null;
      },
      onError: (error, stackTrace) {
        return error;
      },
    );
  }

  bool get isFailed {
    return when(
      onSuccess: (result) {
        return false;
      },
      onError: (error, stackTrace) {
        return true;
      },
    );
  }

  bool get isSuccess {
    return when(
      onSuccess: (result) {
        return true;
      },
      onError: (error, stackTrace) {
        return false;
      },
    );
  }
}

sealed class OperationResult<T> {
  const OperationResult();

  const factory OperationResult.success(T result) = OperationSuccessResult;

  const factory OperationResult.failed({
    required Object error,
    required StackTrace stackTrace,
  }) = OperationFailedResult;

  WhenValue when<WhenValue>({
    required WhenValue Function(T result) onSuccess,
    required WhenValue Function(Object error, StackTrace stackTrace) onError,
  }) {
    return switch (this) {
      OperationSuccessResult<T> e => onSuccess(e.result),
      OperationFailedResult<T> e => onError(e.error, e.stackTrace),
    };
  }

  MapValue? map<MapValue>(
    MapValue? Function(T result)? onSuccess,
    MapValue? Function(Object error, StackTrace stackTrace)? onError,
  ) {
    return when(
      onSuccess: (result) {
        return onSuccess?.call(result);
      },
      onError: (error, stackTrace) {
        return onError?.call(error, stackTrace);
      },
    );
  }
}

class OperationSuccessResult<T> extends OperationResult<T> {
  const OperationSuccessResult(this.result);
  final T result;

  @override
  int get hashCode => Object.hashAll([result]);

  @override
  bool operator ==(covariant OperationSuccessResult<T> other) {
    return result == other.result;
  }
}

class OperationFailedResult<T> extends OperationResult<T> {
  const OperationFailedResult({
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  int get hashCode => Object.hashAll([error, stackTrace]);

  @override
  bool operator ==(covariant OperationFailedResult<T> other) {
    return error == other.error && stackTrace == other.stackTrace;
  }
}
