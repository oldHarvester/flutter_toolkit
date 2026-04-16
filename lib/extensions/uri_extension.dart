extension UriExtension on Uri {
  /// url without query parameters
  String get cleanPath {
    final uri = this;
    return '${uri.scheme}://${uri.host}${uri.path}';
  }
}
