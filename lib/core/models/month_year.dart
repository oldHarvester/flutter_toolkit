import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MonthYear with EquatableMixin {
  const MonthYear({
    required this.month,
    required this.year,
  }) : assert(month >= 1 && month <= 12, 'Month must be between 1 and 12');

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

  bool isDateAfter(DateTime date) {
    return date.isAfter(lastMonth.lastDay);
  }

  bool isDateBefore(DateTime date) {
    return date.isBefore(nextMonth.firstDay);
  }

  bool hasDate(DateTime date) {
    return date.month == month && date.year == year;
  }

  bool isAfter(MonthYear other) {
    if (year > other.year) return true;
    if (year < other.year) return false;
    return month > other.month;
  }

  bool isBefore(MonthYear other) {
    if (year < other.year) return true;
    if (year > other.year) return false;
    return month < other.month;
  }

  bool isSame(MonthYear other) {
    return year == other.year && month == other.month;
  }

  int differenceInMonths(MonthYear other) {
    return (year - other.year) * 12 + (month - other.month);
  }

  MonthYear addMonths(int months) {
    int totalMonths = (year * 12 + month - 1) + months;
    int newYear = totalMonths ~/ 12;
    int newMonth = (totalMonths % 12) + 1;
    return MonthYear(month: newMonth, year: newYear);
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
