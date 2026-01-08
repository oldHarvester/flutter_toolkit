import 'package:flutter/material.dart';

class NamedScaffold extends Scaffold {
  NamedScaffold({super.key, required String name})
      : super(
          body: Center(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        );
}
