import 'package:equatable/equatable.dart';

class DatePeriod with EquatableMixin {
  const DatePeriod({
    this.days = 0,
    this.weeks = 0,
    this.months = 0,
    this.years = 0,
  });

  final int days;
  final int weeks;
  final int months;
  final int years;

  @override
  List<Object?> get props => [days, weeks, months, years];
}
