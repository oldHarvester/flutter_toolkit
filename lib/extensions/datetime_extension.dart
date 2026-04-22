import 'package:flutter/material.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

export 'package:flutter_toolkit/flutter_toolkit.dart' show DatePeriod, MonthYear;

extension DateTimeExtension on DateTime {
  MonthYear get monthYear => MonthYear.fromDate(this);

  DateTime get withoutTime => DateTime(year, month, day);

  Duration get toDuration => Duration(
        microseconds: microsecondsSinceEpoch,
      );

  Duration get time => subtract(withoutTime.toDuration).toDuration;

  DateTime addPeriod(DatePeriod step) {
    // Сначала применяем months и years
    int totalMonths = month + step.months + (step.years * 12);
    int newYear = year + ((totalMonths - 1) ~/ 12);
    int newMonth = ((totalMonths - 1) % 12) + 1;

    // Clamp день до последнего дня в новом месяце
    int maxDay = DateUtils.getDaysInMonth(newYear, newMonth);
    int newDay = day.clamp(1, maxDay);

    DateTime result = DateTime(newYear, newMonth, newDay, hour, minute, second,
        millisecond, microsecond);

    // Затем применяем days и weeks
    return result.add(Duration(days: step.days + step.weeks * 7));
  }

  int get age {
    final today = DateTime.now();
    int age = today.year - year;

    if (today.month < month || (today.month == month && today.day < day)) {
      age--;
    }

    return age;
  }

  bool get isToday {
    final now = DateTime.now();
    return isSameDay(now);
  }

  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(tomorrow);
  }

  bool get isDayUpcoming {
    final today = DateTime.now().withoutTime;
    final day = withoutTime;
    return day.isAfter(today);
  }

  bool get isDayPast {
    final today = DateTime.now().withoutTime;
    final day = withoutTime;
    return day.isBefore(today);
  }

  bool isAfterOrSame(DateTime date) {
    return this == date || isAfter(date);
  }

  bool isBeforeOrSame(DateTime date) {
    return this == date || isBefore(date);
  }
}
