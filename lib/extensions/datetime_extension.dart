import 'package:flutter_toolkit/flutter_toolkit.dart';

extension DateTimeExtension on DateTime {
  MonthYear get monthYear => MonthYear.fromDate(this);

  DateTime get withoutTime => DateTime(year, month, day);

  Duration get toDuration => Duration(
        microseconds: microsecondsSinceEpoch,
      );

  Duration get time => subtract(withoutTime.toDuration).toDuration;

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
}
