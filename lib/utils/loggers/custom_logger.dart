import 'dart:developer' as dev;

class CustomLogger {
  CustomLogger({
    required this.owner,
    this.showLogs = true,
  }) {
    _showLogs = showLogs;
  }

  final String owner;
  final bool showLogs;

  late bool _showLogs;

  void enableLogs() {
    _showLogs = true;
  }

  void disableLogs() {
    _showLogs = false;
  }

  void log([
    Object? object,
    String? owner,
  ]) {
    if (!_showLogs) {
      return;
    }
    dev.log(
      object.toString(),
      name: owner ?? this.owner,
    );
  }
}
