import 'package:equatable/equatable.dart';
import '../../../data/models/movie_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final MovieModel featuredMovie;
  final List<MovieModel> popularMovies;
  final List<MovieModel> trendingMovies;
  final List<MovieModel> nowPlayingMovies;
  final List<MovieModel> topRatedMovies;

  const HomeLoaded({
    required this.featuredMovie,
    required this.popularMovies,
    required this.trendingMovies,
    required this.nowPlayingMovies,
    required this.topRatedMovies,
  });

  @override
  List<Object?> get props => [
        featuredMovie,
        popularMovies,
        trendingMovies,
        nowPlayingMovies,
        topRatedMovies,
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
