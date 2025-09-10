import 'dart:developer' as dev;

class CustomLogger {
  CustomLogger({
    required this.owner,
  });

  final String owner;

  void log([
    Object? object,
    String? owner,
  ]) {
    dev.log(
      object.toString(),
      name: owner ?? this.owner,
    );
  }
}
