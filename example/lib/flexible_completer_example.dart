import 'package:flutter/material.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class FlexibleCompleterExample extends StatefulWidget {
  const FlexibleCompleterExample({super.key});

  @override
  State<FlexibleCompleterExample> createState() => _FlexibleCompleterExampleState();
}

class _FlexibleCompleterExampleState extends State<FlexibleCompleterExample> {
  Future<bool> foo() {
    final completer = FlexibleCompleter<bool>(
      onCancel: () {
        print('on cancel');
      },
      onTimeout: () {
        print('on timeout');
      },
      onReceived: (value, cancelledResult) {
        print('on received');
      },
      // timeoutDuration: Duration.zero,
    );
    Future.delayed(Duration(seconds: 5), () {
      completer.cancel();
    });
    Future.delayed(Duration(seconds: 4), () {
      completer.complete(true);
    });
    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    foo()
        .then((value) {
          print('receive value: $value');
        })
        .catchError((error) {
          print('catch error: $error');
        });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
