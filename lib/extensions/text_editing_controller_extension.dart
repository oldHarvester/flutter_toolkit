import 'package:flutter/material.dart';

extension TextEditingControllerExtension on TextEditingController {
  void update(String? value) {
    text = value ?? '';
  }
}
