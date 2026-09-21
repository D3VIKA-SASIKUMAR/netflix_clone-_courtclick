import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/movie_response.dart';

abstract class TMDBApiService {
  Future<MovieResponse> getTrendingMovies({int page = 1});
  Future<MovieResponse> getPopularMovies({int page = 1});
  Future<MovieResponse> getNowPlayingMovies({int page = 1});
  Future<MovieResponse> getTopRatedMovies({int page = 1});
  Future<MovieResponse> getUpcomingMovies({int page = 1});
  Future<MovieResponse> searchMovies({required String query, int page = 1});
}

class TMDBApiServiceImpl implements TMDBApiService {
  final DioClient dioClient;

  TMDBApiServiceImpl({required this.dioClient});

  @override
  Future<MovieResponse> getTrendingMovies({int page = 1}) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.trending,
        queryParameters: {'page': page},
      );
      return MovieResponse.fromJson(response.data);
    } catch (_) {
      return getPopularMovies(page: page);
    }
  }

  @override
  Future<MovieResponse> getPopularMovies({int page = 1}) async {
    final response = await dioClient.get(
      ApiEndpoints.popular,
      queryParameters: {'page': page},
    );
    return MovieResponse.fromJson(response.data);
  }

  @override
  Future<MovieResponse> getNowPlayingMovies({int page = 1}) async {
    final response = await dioClient.get(
      ApiEndpoints.nowPlaying,
      queryParameters: {'page': page},
    );
    return MovieResponse.fromJson(response.data);
  }

  @override
  Future<MovieResponse> getTopRatedMovies({int page = 1}) async {
    final response = await dioClient.get(
      ApiEndpoints.topRated,
      queryParameters: {'page': page},
    );
    return MovieResponse.fromJson(response.data);
  }

  @override
  Future<MovieResponse> getUpcomingMovies({int page = 1}) async {
    final response = await dioClient.get(
      ApiEndpoints.upcoming,
      queryParameters: {'page': page},
    );
    return MovieResponse.fromJson(response.data);
  }

  @override
  Future<MovieResponse> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final response = await dioClient.get(
      ApiEndpoints.search,
      queryParameters: {'query': query, 'page': page},
    );
    return MovieResponse.fromJson(response.data);
  }
}
