import 'package:equatable/equatable.dart';
import 'movie_model.dart';

class MovieResponse extends Equatable {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  const MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as List<dynamic>? ?? [];
    final movies = rawResults
        .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return MovieResponse(
      page: json['page'] ?? 1,
      results: movies,
      totalPages: json['total_pages'] ?? 1,
      totalResults: json['total_results'] ?? movies.length,
    );
  }

  @override
  List<Object?> get props => [page, results, totalPages, totalResults];
}
