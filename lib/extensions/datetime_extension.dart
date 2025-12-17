import 'package:flutter_toolkit/flutter_toolkit.dart';

extension DateTimeExtension on DateTime {
  MonthYear get monthYear => MonthYear.fromDate(this);
}
