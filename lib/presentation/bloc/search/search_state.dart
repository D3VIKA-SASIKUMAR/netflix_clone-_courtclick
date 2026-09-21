import 'package:equatable/equatable.dart';
import '../../../data/models/movie_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class PopularSearchesLoaded extends SearchState {
  final List<MovieModel> movies;
  const PopularSearchesLoaded({required this.movies});

  @override
  List<Object?> get props => [movies];
}

class SearchLoaded extends SearchState {
  final String query;
  final List<MovieModel> movies;
  const SearchLoaded({required this.query, required this.movies});
  @override
  List<Object?> get props => [query, movies];
}

class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty({required this.query});
  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;
  const SearchError({required this.message});
  @override
  List<Object?> get props => [message];
}
