import 'package:dio/dio.dart';
import '../datasources/tmdb_api_service.dart';
import '../models/movie_response.dart';

abstract class MovieRepository {
  Future<MovieResponse> getTrendingMovies({int page = 1});
  Future<MovieResponse> getPopularMovies({int page = 1});
  Future<MovieResponse> getNowPlayingMovies({int page = 1});
  Future<MovieResponse> getTopRatedMovies({int page = 1});
  Future<MovieResponse> getUpcomingMovies({int page = 1});
  Future<MovieResponse> searchMovies({required String query, int page = 1});
}

class MovieRepositoryImpl implements MovieRepository {
  final TMDBApiService apiService;

  MovieRepositoryImpl({required this.apiService});

  @override
  Future<MovieResponse> getTrendingMovies({int page = 1}) async {
    try {
      return await apiService.getTrendingMovies(page: page);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  @override
  Future<MovieResponse> getPopularMovies({int page = 1}) async {
    try {
      return await apiService.getPopularMovies(page: page);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  @override
  Future<MovieResponse> getNowPlayingMovies({int page = 1}) async {
    try {
      return await apiService.getNowPlayingMovies(page: page);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  @override
  Future<MovieResponse> getTopRatedMovies({int page = 1}) async {
    try {
      return await apiService.getTopRatedMovies(page: page);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  @override
  Future<MovieResponse> getUpcomingMovies({int page = 1}) async {
    try {
      return await apiService.getUpcomingMovies(page: page);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  @override
  Future<MovieResponse> searchMovies({required String query, int page = 1}) async {
    try {
      return await apiService.searchMovies(query: query, page: page);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'Unauthorized API request. Please verify your TMDB API Key.';
        } else if (statusCode == 404) {
          return 'Resource not found.';
        }
        return 'Server error ($statusCode). Please try again later.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      default:
        return 'Network connection failed. Please check your network connection.';
    }
  }
}
