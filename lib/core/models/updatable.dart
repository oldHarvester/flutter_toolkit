import 'package:equatable/equatable.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class Updatable<T> with EquatableMixin {
  const Updatable({required this.value});
  final T value;

  @override
  List<Object?> get props => [FlexibleEquality().hash(value)];
}
