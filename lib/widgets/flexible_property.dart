import 'package:flutter/material.dart';

typedef NewWidgetStateProperty<T> = FlexibleProperty<T, Set<WidgetState>>;

typedef FlexiblePropertyResolver<Value, State> = Value Function(
  State state,
);

abstract class FlexibleProperty<Value, State> {
  Value resolve(State state);

  static FlexibleProperty<Value, State> resolveWith<Value, State>(
    FlexiblePropertyResolver<Value, State> callback,
  ) {
    return FlexiblePropertyResolveWith<Value, State>(callback);
  }

  static FlexibleProperty<Value, State> all<Value, State>(Value value) {
    return FlexiblePropertyAll(value: value);
  }

  static FlexibleProperty<Value?, State> lerp<Value, State>({
    required double t,
    required Value? Function(Value? old, Value? current, double t) lerpFunction,
    FlexibleProperty<Value, State>? a,
    FlexibleProperty<Value, State>? b,
  }) {
    return FlexiblePropertyLerp<Value, State>(
      a: a,
      b: b,
      t: t,
      lerpFunction: lerpFunction,
    );
  }
}

class FlexiblePropertyAll<Value, State>
    implements FlexibleProperty<Value, State> {
  const FlexiblePropertyAll({required this.value});
  final Value value;

  @override
  Value resolve(State state) => value;
}

class FlexiblePropertyResolveWith<Value, State>
    implements FlexibleProperty<Value, State> {
  const FlexiblePropertyResolveWith(this.resolver);

  final FlexiblePropertyResolver<Value, State> resolver;

  @override
  Value resolve(State state) => resolver(state);
}

class FlexiblePropertyLerp<Value, State>
    implements FlexibleProperty<Value?, State> {
  const FlexiblePropertyLerp({
    required this.a,
    required this.b,
    required this.t,
    required this.lerpFunction,
  });

  final double t;
  final FlexibleProperty<Value, State>? a;
  final FlexibleProperty<Value, State>? b;
  final Value? Function(Value? old, Value? current, double t) lerpFunction;

  @override
  Value? resolve(State state) {
    final resolvedA = a?.resolve(state);
    final resolvedB = b?.resolve(state);
    return lerpFunction(resolvedA, resolvedB, t);
  }
}
