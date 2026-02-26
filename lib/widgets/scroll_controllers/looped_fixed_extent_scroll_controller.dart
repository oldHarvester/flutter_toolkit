import 'package:flutter/material.dart';

class LoopedFixedExtentScrollController extends FixedExtentScrollController {
  LoopedFixedExtentScrollController({
    super.initialItem,
    super.debugLabel,
    super.onAttach,
    super.onDetach,
    required this.totalCount,
  });

  final int totalCount;

  int get relativeItem {
    if (totalCount <= 0) return 0;
    // Используем оператор остатка от деления
    // В Dart % всегда возвращает положительное число, если делитель положителен
    return selectedItem % totalCount;
  }

  @override
  Future<void> animateToItem(
    int itemIndex, {
    required Duration duration,
    required Curve curve,
  }) {
    return _animateToNearest(
      index: itemIndex,
      curve: curve,
      duration: duration,
    );
  }

  Future<void> _animateToNearest({
    required int index,
    required Duration duration,
    required Curve curve,
  }) {
    int currentIndex = selectedItem;

    // Находим разницу
    int diff = index - currentIndex;

    // Корректируем разницу для зацикленного списка
    if (diff > totalCount / 2) {
      diff -= totalCount; // Выгоднее крутить назад
    } else if (diff < -totalCount / 2) {
      diff += totalCount; // Выгоднее крутить вперед
    }

    return super.animateToItem(
      currentIndex + diff,
      duration: duration,
      curve: curve,
    );
  }
}
