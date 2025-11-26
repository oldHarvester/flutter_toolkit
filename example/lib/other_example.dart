import 'package:flutter/material.dart';

class OtherExamplePage extends StatefulWidget {
  const OtherExamplePage({super.key});

  @override
  State<OtherExamplePage> createState() => _OtherExamplePageState();
}

class _OtherExamplePageState extends State<OtherExamplePage> {
  void foo() {}

  @override
  void initState() {
    // final a = foo().safeExecute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
