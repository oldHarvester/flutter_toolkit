import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../models/nullable.dart';

class ThrottleValue<T> extends Equatable {
  const ThrottleValue({
    required this.current,
    required this.pending,
  });

  final T current;
  final T? pending;

  @override
  List<Object?> get props => [current, pending];

  ThrottleValue<T> copyWith({
    T? current,
    Nullable<T?>? pending,
  }) {
    return ThrottleValue<T>(
      current: current ?? this.current,
      pending: pending == null ? this.pending : pending.value,
    );
  }
}

class ThrottlingController<T> extends ChangeNotifier
    implements ValueListenable<T> {
  ThrottlingController(
    T value, {
    this.notifyPending = true,
    Duration duration = const Duration(
      seconds: 1,
      milliseconds: 300,
    ),
  })  : _duration = duration,
        _initialValue = value,
        _value = ThrottleValue(
          current: value,
          pending: null,
        );

  Timer? _timer;

  final T _initialValue;

  final bool notifyPending;

  final Duration _duration;

  ThrottleValue<T> _value;

  set value(T value) {
    if (_timer == null) {
      _timer = Timer(
        _duration,
        () {
          _timer = null;
          final pending = _value.pending;
          if (pending != null) {
            _value = _value.copyWith(
              current: pending,
              pending: Nullable(null),
            );
            notifyListeners();
          }
        },
      );
      _value = _value.copyWith(
        current: value,
      );
      notifyListeners();
    } else {
      _value = _value.copyWith(
        pending: Nullable(value),
      );
      if (notifyPending) {
        notifyListeners();
      }
    }
  }

  void reset({bool notify = true}) {
    _value = ThrottleValue(
      current: _initialValue,
      pending: null,
    );
    if (notify) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  T? get pendingValue => _value.pending;

  @override
  T get value => _value.current;
}
