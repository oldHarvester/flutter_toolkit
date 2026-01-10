extension DurationExtension on Duration {
  Duration clamp({Duration? min, Duration? max}) {
    var temp = this;
    if (min != null && min > temp) {
      temp = min;
    }

    if (max != null && temp > max) {
      temp = max;
    }
    return temp;
  }

  double operator /(Duration other) {
    return inMicroseconds / other.inMicroseconds;
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String get hh => twoDigits(inHours);

  String get mm => twoDigits(inMinutes.remainder(60));

  String get ss => twoDigits(inSeconds.remainder(60));

  String hhmmss([String divider = ':']) {
    return [hh, mm, ss].join(divider);
  }

  String hhmm([String divider = ':']) {
    return [hh, mm].join(divider);
  }
}
