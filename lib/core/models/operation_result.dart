import 'package:equatable/equatable.dart';

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

sealed class OperationResult<T> with EquatableMixin {
  const OperationResult({
    required this.elapsedTime,
  });

  final Duration elapsedTime;

  const factory OperationResult.success(
    T result, {
    required Duration elapsedTime,
  }) = OperationSuccessResult;

  const factory OperationResult.failed({
    required Duration elapsedTime,
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

  @override
  List<Object?> get props => [elapsedTime];
}

class OperationSuccessResult<T> extends OperationResult<T> {
  const OperationSuccessResult(
    this.result, {
    required super.elapsedTime,
  });

  final T result;

  @override
  List<Object?> get props => [...super.props, result];
}

class OperationFailedResult<T> extends OperationResult<T> {
  const OperationFailedResult({
    required this.error,
    required this.stackTrace,
    required super.elapsedTime,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [...super.props, error, stackTrace];
}
