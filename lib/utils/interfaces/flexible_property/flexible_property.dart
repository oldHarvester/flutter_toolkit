import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

typedef FlexiblePropertyResolver<Value, State> = Value Function(
  State state,
);

abstract class FlexibleProperty<Value, State> {
  const FlexibleProperty();

  const factory FlexibleProperty.all(Value value) =
      FlexiblePropertyAll<Value, State>;

  const factory FlexibleProperty.resolveWith(
    FlexiblePropertyResolver<Value, State> resolver,
  ) = FlexiblePropertyResolveWith<Value, State>;

  static FlexibleProperty<Value?, State> lerp<Value, State>(
    FlexibleProperty<Value, State>? a,
    FlexibleProperty<Value, State>? b,
    double t,
    Value? Function(Value? old, Value? current, double t) lerpFunction,
  ) {
    return FlexiblePropertyLerp<Value, State>(a, b, t, lerpFunction);
  }

  static FlexibleProperty<Value, State> lerpForce<Value, State>(
    FlexibleProperty<Value, State> a,
    FlexibleProperty<Value, State> b,
    double t,
    Value Function(Value a, Value b, double t) lerpFunction,
  ) {
    return FlexiblePropertyForceLerp<Value, State>(a, b, t, lerpFunction);
  }

  Value resolve(State state);
}

class FlexiblePropertyAll<Value, State> extends FlexibleProperty<Value, State>
    with EquatableMixin {
  const FlexiblePropertyAll(this.value);
  final Value value;

  @override
  Value resolve(State state) => value;

  @override
  List<Object?> get props => [
        value is Map || value is Iterable
            ? DeepCollectionEquality().hash(value)
            : value,
      ];
}

class FlexiblePropertyResolveWith<Value, State>
    extends FlexibleProperty<Value, State> {
  const FlexiblePropertyResolveWith(this.resolver);

  final FlexiblePropertyResolver<Value, State> resolver;

  @override
  Value resolve(State state) => resolver(state);
}

class FlexiblePropertyLerp<Value, State>
    implements FlexibleProperty<Value?, State> {
  const FlexiblePropertyLerp(
    this.a,
    this.b,
    this.t,
    this.lerpFunction,
  );

  final double t;
  final FlexibleProperty<Value, State>? a;
  final FlexibleProperty<Value, State>? b;
  final Value? Function(Value? a, Value? b, double t) lerpFunction;

  @override
  Value? resolve(State state) {
    final resolvedA = a?.resolve(state);
    final resolvedB = b?.resolve(state);
    return lerpFunction(resolvedA, resolvedB, t);
  }
}

class FlexiblePropertyForceLerp<Value, State>
    implements FlexibleProperty<Value, State> {
  const FlexiblePropertyForceLerp(
    this.a,
    this.b,
    this.t,
    this.lerpFunction,
  );

  final double t;
  final FlexibleProperty<Value, State> a;
  final FlexibleProperty<Value, State> b;
  final Value Function(Value old, Value current, double t) lerpFunction;

  @override
  Value resolve(State state) {
    final resolvedA = a.resolve(state);
    final resolvedB = b.resolve(state);
    return lerpFunction(resolvedA, resolvedB, t);
  }
}
