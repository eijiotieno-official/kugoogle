class UrlUtil {
  static const String _baseUrl = "https://duckduckgo.com/?q=";

  /// Returns a fully encoded URL string using the base URL.
  static String encodeUrl(String query) {
    return '$_baseUrl${Uri.encodeComponent(query)}';
  }

  /// Returns a parsed Uri object from the encoded query.
  static Uri parsedUrl(String query) {
    return Uri.parse(encodeUrl(query));
  }
}
