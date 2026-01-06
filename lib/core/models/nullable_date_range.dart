import 'package:equatable/equatable.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class NullableDateRange with EquatableMixin {
  NullableDateRange({
    DateTime? fromDate,
    DateTime? toDate,
  })  : fromDate = fromDate?.withoutTime,
        toDate = toDate?.withoutTime;

  final DateTime? fromDate;
  final DateTime? toDate;

  NullableDateRange sort() {
    final fromDate = this.fromDate;
    final toDate = this.toDate;
    if (fromDate == null && toDate == null) {
      return NullableDateRange();
    } else if (fromDate != null && toDate == null) {
      return this;
    } else if (fromDate == null && toDate != null) {
      return NullableDateRange(
        fromDate: toDate,
      );
    } else if (fromDate == toDate) {
      return NullableDateRange(fromDate: fromDate);
    } else if (fromDate != null && toDate != null) {
      return NullableDateRange(
        fromDate: fromDate.isAfter(toDate) ? toDate : fromDate,
        toDate: toDate.isBefore(fromDate) ? fromDate : toDate,
      );
    } else {
      return this;
    }
  }

  NullableDateRange fillIfEmpty(DateTime? date) {
    final fromDate = this.fromDate;
    final toDate = this.toDate;
    if (fromDate == null && toDate == null) {
      return NullableDateRange(
        fromDate: date,
      );
    }
    return NullableDateRange(
      fromDate: fromDate ?? date,
      toDate: toDate ?? date,
    );
  }

  bool get rangeFilled {
    return toDate != null && fromDate != null;
  }

  bool get isEmpty {
    return fromDate == null && toDate == null;
  }

  bool get isNotEmpty => !isEmpty;

  bool get partiallyFilled {
    return isNotEmpty && !rangeFilled;
  }

  bool isSelected(DateTime date) {
    date = date.withoutTime;
    return fromDate == date || toDate == date;
  }

  bool isInside(DateTime date) {
    date = date.withoutTime;
    final fromDate = this.fromDate;
    final toDate = this.toDate;
    if (fromDate == null || toDate == null) {
      return false;
    }
    if (isSelected(date)) {
      return true;
    }
    return (date.isAfter(fromDate) && date.isBefore(toDate)) ||
        (date.isAfter(toDate) && date.isBefore(fromDate));
  }

  NullableDateRange copyWith({
    Nullable<DateTime>? fromDate,
    Nullable<DateTime>? toDate,
  }) {
    return NullableDateRange(
      fromDate: fromDate == null ? this.fromDate : fromDate.value?.withoutTime,
      toDate: toDate == null ? this.toDate : toDate.value?.withoutTime,
    );
  }

  @override
  List<Object?> get props => [fromDate, toDate];
}
