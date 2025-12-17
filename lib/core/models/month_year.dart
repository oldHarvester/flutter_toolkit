import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MonthYear with EquatableMixin {
  const MonthYear({
    required this.month,
    required this.year,
  });

  MonthYear.fromDate(DateTime date)
      : month = date.month,
        year = date.year;

  MonthYear.now()
      : month = DateTime.now().month,
        year = DateTime.now().year;

  DateTime toDate({int? day}) {
    return DateTime(year, month, day ?? 1);
  }

  MonthYear get lastMonth {
    return MonthYear.fromDate(
      firstDay.subtract(
        Duration(days: 1),
      ),
    );
  }

  MonthYear get nextMonth {
    return MonthYear.fromDate(
      lastDay.add(
        Duration(days: 1),
      ),
    );
  }

  DateTime get firstDay {
    return toDate(day: 1);
  }

  DateTime get lastDay {
    return toDate(day: daysInMonth);
  }

  bool hasDate(DateTime date) {
    return date.month == month && date.year == year;
  }

  MonthYear copyWith({
    int? month,
    int? year,
  }) {
    return MonthYear(
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  int get daysInMonth {
    return DateUtils.getDaysInMonth(
      year,
      month,
    );
  }

  int firstDayOffset(MaterialLocalizations localizations) {
    return DateUtils.firstDayOffset(
      year,
      month,
      localizations,
    );
  }

  final int month;
  final int year;

  @override
  List<Object?> get props => [month, year];
}
