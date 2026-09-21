import '../config/api_config.dart';

class ApiEndpoints {
  static const String trending = '/trending/movie/week';
  static const String popular = '/movie/popular';
  static const String nowPlaying = '/movie/now_playing';
  static const String topRated = '/movie/top_rated';
  static const String upcoming = '/movie/upcoming';
  static const String search = '/search/movie';

  static String imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${ApiConfig.imageBaseUrl}$path';
  }

  static String backdropUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${ApiConfig.backdropBaseUrl}$path';
  }
}
