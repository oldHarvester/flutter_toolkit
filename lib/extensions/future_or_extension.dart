import 'dart:async';

import 'package:flutter_toolkit/flutter_toolkit.dart';

extension FutureOrExtension<T> on FutureOr<T> {
  WhenValue asyncOrSync<WhenValue>({
    required WhenValue Function(T value) synchronous,
    required WhenValue Function(Future<T> value) asynchronous,
  }) {
    final futureOr = this;
    if (futureOr is T) {
      return synchronous(futureOr);
    } else {
      return asynchronous(futureOr);
    }
  }

  Future<T>? get asyncValue {
    return asyncOrSync(
      synchronous: (value) {
        return null;
      },
      asynchronous: (value) {
        return value;
      },
    );
  }

  T? get syncValue {
    return asyncOrSync(
      synchronous: (value) {
        return value;
      },
      asynchronous: (value) {
        return null;
      },
    );
  }

  FutureOr<OperationResult<T>> safeExecute() {
    return asyncOrSync(
      synchronous: (value) {
        return value.safeExecute();
      },
      asynchronous: (value) {
        return value.safeExecute();
      },
    );
  }
}
