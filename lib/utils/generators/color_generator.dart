import 'dart:ui';

class ColorGenerator {
  ColorGenerator({
    this.colors = _palette,
  });

  static const List<Color> _palette = [
    Color(0xFFE57373),
    Color(0xFF81C784),
    Color(0xFF64B5F6),
    Color(0xFFFFD54F),
    Color(0xFFBA68C8),
    Color(0xFF4DB6AC),
    Color(0xFFFF8A65),
    Color(0xFFA1887F),
    Color(0xFF90A4AE),
    Color(0xFFF06292),
    Color(0xFFAED581),
    Color(0xFF4FC3F7),
    Color(0xFFFFB74D),
    Color(0xFF9575CD),
    Color(0xFF4DD0E1),
  ];

  final List<Color> colors;

  int _index = 0;

  Color generateColor() {
    final color = _palette[_index % _palette.length];
    _index++;
    return color;
  }

  void reset() => _index = 0;
}
