import 'package:flutter/material.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
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
