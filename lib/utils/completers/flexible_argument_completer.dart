import 'package:flutter_toolkit/utils/completers/flexible_completer.dart';

class FlexibleArgumentCompleter<T, Y> extends FlexibleCompleter<T> {
  FlexibleArgumentCompleter({
    required this.arg,
    super.onCancel,
    super.onTimeout,
    super.timeoutDuration,
  });
  final Y arg;
}
