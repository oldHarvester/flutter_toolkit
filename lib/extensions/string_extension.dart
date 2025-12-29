extension StringExtension on String {
  bool get hasContent =>
      isNotEmpty && trim().isNotEmpty && replaceAll(' ', '').isNotEmpty;
}
