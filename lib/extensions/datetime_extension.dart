import 'package:flutter_toolkit/flutter_toolkit.dart';

extension DateTimeExtension on DateTime {
  MonthYear get monthYear => MonthYear.fromDate(this);

  DateTime get withoutTime => DateTime(year, month, day);

  int get age {
    final today = DateTime.now();
    int age = today.year - year;

    if (today.month < month || (today.month == month && today.day < day)) {
      age--;
    }

    return age;
  }
}
