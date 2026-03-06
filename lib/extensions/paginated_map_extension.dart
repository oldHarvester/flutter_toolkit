extension MapExtension<Z> on Map<int, List<Z>> {
  void removePaginated({
    required int pageIndex,
    required int itemIndex,
    required int limit,
  }) {
    // 1. Собираем все элементы в плоский список
    final List<Z> flat = [];
    final sortedKeys = keys.toList()..sort();
    for (final key in sortedKeys) {
      flat.addAll(this[key]!);
    }

    // 2. Вычисляем глобальный индекс удаляемого элемента
    final globalIndex = pageIndex * limit + itemIndex;
    if (globalIndex < 0 || globalIndex >= flat.length) {
      throw RangeError('Элемент не найден: page=$pageIndex, item=$itemIndex');
    }

    // 3. Удаляем элемент
    flat.removeAt(globalIndex);

    // 4. Мутируем оригинальный Map
    clear();
    for (int i = 0; i < flat.length; i += limit) {
      final page = i ~/ limit;
      this[page] = flat.sublist(i, (i + limit).clamp(0, flat.length));
    }
  }

  void insertPaginated({
    required Z newItem,
    required int pageIndex,
    required int itemIndex,
    required int limit,
  }) {
    // 1. Собираем все элементы в плоский список
    final List<Z> flat = [];
    final sortedKeys = keys.toList()..sort();
    for (final key in sortedKeys) {
      flat.addAll(this[key]!);
    }

    // 2. Вычисляем глобальный индекс куда вставляем
    final globalIndex = pageIndex * limit + itemIndex;
    if (globalIndex < 0 || globalIndex > flat.length) {
      throw RangeError('Некорректный индекс: page=$pageIndex, item=$itemIndex');
    }

    // 3. Вставляем элемент
    flat.insert(globalIndex, newItem);

    // 4. Мутируем оригинальный Map
    clear();
    for (int i = 0; i < flat.length; i += limit) {
      final page = i ~/ limit;
      this[page] = flat.sublist(i, (i + limit).clamp(0, flat.length));
    }
  }

  void insertAllPaginated({
    required List<Z> newItems,
    required int pageIndex,
    required int itemIndex,
    required int limit,
  }) {
    // 1. Собираем все элементы в плоский список
    final List<Z> flat = [];
    final sortedKeys = keys.toList()..sort();
    for (final key in sortedKeys) {
      flat.addAll(this[key]!);
    }

    // 2. Вычисляем глобальный индекс куда вставляем
    final globalIndex = pageIndex * limit + itemIndex;
    if (globalIndex < 0 || globalIndex > flat.length) {
      throw RangeError('Некорректный индекс: page=$pageIndex, item=$itemIndex');
    }

    // 3. Вставляем все элементы начиная с globalIndex
    flat.insertAll(globalIndex, newItems);

    // 4. Мутируем оригинальный Map
    clear();
    for (int i = 0; i < flat.length; i += limit) {
      final page = i ~/ limit;
      this[page] = flat.sublist(i, (i + limit).clamp(0, flat.length));
    }
  }
}
