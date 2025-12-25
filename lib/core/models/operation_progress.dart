extension OperationProgressExtension<T> on OperationProgress<T> {
  T? get result {
    return when(
      processing: () {
        return null;
      },
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
      processing: () => null,
      onSuccess: (result) => null,
      onError: (error, stackTrace) => error,
    );
  }

  bool get isFailed {
    return when(
      processing: () => false,
      onSuccess: (result) => false,
      onError: (error, stackTrace) => false,
    );
  }

  bool get isSuccess {
    return when(
      processing: () => false,
      onError: (error, stackTrace) => false,
      onSuccess: (result) => true,
    );
  }

  bool get isProcessing {
    return when(
      onSuccess: (result) => false,
      onError: (error, stackTrace) => false,
      processing: () => true,
    );
  }
}

sealed class OperationProgress<T> {
  const OperationProgress();

  const factory OperationProgress.processing() = OperationProcessing;

  const factory OperationProgress.success(T result) = OperationProgressSuccess;

  const factory OperationProgress.failed({
    required Object error,
    required StackTrace stackTrace,
  }) = OperationProgressFailed;

  WhenValue when<WhenValue>({
    required WhenValue Function() processing,
    required WhenValue Function(T result) onSuccess,
    required WhenValue Function(Object error, StackTrace stackTrace) onError,
  }) {
    return switch (this) {
      OperationProcessing<T> _ => processing(),
      OperationProgressSuccess<T> e => onSuccess(e.result),
      OperationProgressFailed<T> e => onError(e.error, e.stackTrace),
    };
  }

  MapValue? map<MapValue>(
    MapValue? Function()? processing,
    MapValue? Function(T result)? onSuccess,
    MapValue? Function(Object error, StackTrace stackTrace)? onError,
  ) {
    return when(
      processing: () => processing?.call(),
      onSuccess: (result) {
        return onSuccess?.call(result);
      },
      onError: (error, stackTrace) {
        return onError?.call(error, stackTrace);
      },
    );
  }
}

class OperationProgressSuccess<T> extends OperationProgress<T> {
  const OperationProgressSuccess(this.result);
  final T result;

  @override
  int get hashCode => Object.hashAll([result]);

  @override
  bool operator ==(covariant OperationProgressSuccess<T> other) {
    return result == other.result;
  }
}

class OperationProgressFailed<T> extends OperationProgress<T> {
  const OperationProgressFailed({
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  int get hashCode => Object.hashAll([error, stackTrace]);

  @override
  bool operator ==(covariant OperationProgressFailed<T> other) {
    return error == other.error && stackTrace == other.stackTrace;
  }
}

class OperationProcessing<T> extends OperationProgress<T> {
  const OperationProcessing();
}
