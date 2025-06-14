import 'package:equatable/equatable.dart';

class Nullable<T> extends Equatable {
  const Nullable(this.value);
  final T? value;

  @override
  List<Object?> get props => [value];
}
