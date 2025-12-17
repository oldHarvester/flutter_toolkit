import 'package:equatable/equatable.dart';

class Date with EquatableMixin {
  const Date(
    this.year,
    this.month,
    this.day,
  );

  factory Date.now() {
    final now = DateTime.now();
    return Date(now.year, now.month, now.day);
  }

  Date.fromDateTime(DateTime dateTime)
      : year = dateTime.year,
        month = dateTime.month,
        day = dateTime.day;

  DateTime toDateTime({
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) {
    return DateTime(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  final int year;
  final int month;
  final int day;

  @override
  List<Object?> get props => [year, month, day];
}
