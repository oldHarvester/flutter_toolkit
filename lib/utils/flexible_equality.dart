class FlexibleEquality {
  const FlexibleEquality();

  bool equals(Object? a, Object? b) {
    if (!(a != null && b != null)) return false;
    if (identical(a, b)) return true;
    if (a.runtimeType != b.runtimeType) return false;

    return switch (a) {
      final List<dynamic> l => listsEquals(l, b as List<dynamic>),
      final Set<dynamic> s => setsEquals(s, b as Set<dynamic>),
      final Map<dynamic, dynamic> m =>
        mapsEquals(m, b as Map<dynamic, dynamic>),
      final Iterable<dynamic> i => iterablesEquals(i, b as Iterable<dynamic>),
      _ => a == b,
    };
  }

  bool listsEquals(List<dynamic> a, List<dynamic> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (!itemEquals(a[i], b[i])) return false;
    }
    return true;
  }

  bool setsEquals(Set<dynamic> a, Set<dynamic> b) {
    if (a.length != b.length) return false;
    for (final itemA in a) {
      final match = b.any((itemB) => itemEquals(itemA, itemB));
      if (!match) return false;
    }
    return true;
  }

  bool mapsEquals(Map<dynamic, dynamic> a, Map<dynamic, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;
      if (!itemEquals(a[key], b[key])) return false;
    }
    return true;
  }

  bool iterablesEquals(Iterable<dynamic> a, Iterable<dynamic> b) {
    final iterA = a.iterator;
    final iterB = b.iterator;
    while (true) {
      final hasA = iterA.moveNext();
      final hasB = iterB.moveNext();
      if (hasA != hasB) return false;
      if (!hasA) return true;
      if (!itemEquals(iterA.current, iterB.current)) return false;
    }
  }

  bool itemEquals(dynamic a, dynamic b) {
    if (a is Object && b is Object) return equals(a, b);
    return a == b;
  }

  int hash(Object? obj) {
    if (obj == null) return null.hashCode;

    return switch (obj) {
      final List<dynamic> l => listHash(l),
      final Set<dynamic> s => setHash(s),
      final Map<dynamic, dynamic> m => mapHash(m),
      final Iterable<dynamic> i => iterableHash(i),
      _ => obj.hashCode,
    };
  }

  int listHash(List<dynamic> list) {
    var result = 0;
    for (final item in list) {
      result = Object.hash(result, itemHash(item));
    }
    return Object.hash(List, result);
  }

  int setHash(Set<dynamic> set) {
    // XOR — порядок не важен, как и в setsEquals
    var result = 0;
    for (final item in set) {
      result ^= itemHash(item);
    }
    return Object.hash(Set, result);
  }

  int mapHash(Map<dynamic, dynamic> map) {
    // XOR пар ключ+значение — порядок ключей не важен
    var result = 0;
    for (final entry in map.entries) {
      result ^= Object.hash(itemHash(entry.key), itemHash(entry.value));
    }
    return Object.hash(Map, result);
  }

  int iterableHash(Iterable<dynamic> iterable) {
    var result = 0;
    for (final item in iterable) {
      result = Object.hash(result, itemHash(item));
    }
    return Object.hash(Iterable, result);
  }

  int itemHash(dynamic item) {
    if (item is Object) return hash(item);
    return item.hashCode;
  }
}
