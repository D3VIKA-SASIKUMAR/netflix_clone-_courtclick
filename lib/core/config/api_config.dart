class ApiConfig {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/original';
  static const String apiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: 'a07e22bc18f5cb106bfe4cc1f83ad8ed',
  );
}
