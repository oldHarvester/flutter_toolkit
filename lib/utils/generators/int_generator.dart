final class IntGenerator {
  IntGenerator({
    this.from = 0,
    this.to,
    this.loopBackOnExceed = false,
  }) {
    _temp = from;
  }

  final int from;
  final int? to;
  final bool loopBackOnExceed;
  late int _temp;

  int generate() {
    var next = _temp + 1;
    final to = this.to;
    if (to != null && next > to) {
      if (!loopBackOnExceed) {
        throw UnimplementedError();
      }
      next = from;
    }
    _temp = next;
    return next;
  }
}
