extension UriExtension on Uri {
  /// url without query parameters
  String get cleanPath {
    final uri = this;
    return '${uri.scheme}://${uri.host}${uri.path}';
  }

  String? get filename {
    final segments = pathSegments;
    if (segments.isEmpty) return null;
    final last = segments.last;
    final dot = last.lastIndexOf('.');
    if (dot == -1 || dot == 0 || dot == last.length - 1) return null;
    return last;
  }
}
