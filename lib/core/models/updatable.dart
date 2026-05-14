import 'package:equatable/equatable.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

extension NullableUpdatableExtension<T> on Updatable<T?> {
  Updatable<T?>? ifChanged(T? field) {
    return Updatable.ifChanged(this, field);
  }
}

class Updatable<T> with EquatableMixin {
  const Updatable(this.value);
  final T value;

  static Updatable<T?>? ifChanged<T>(Updatable<T?>? param, T? field) {
    if (param == null || param.value == field) {
      return null;
    }
    return param;
  }

  @override
  List<Object?> get props => [FlexibleEquality().hash(value)];
}
