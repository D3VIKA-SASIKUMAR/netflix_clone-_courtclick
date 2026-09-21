import 'package:equatable/equatable.dart';
import '../../../data/models/movie_model.dart';

abstract class ComingSoonState extends Equatable {
  const ComingSoonState();

  @override
  List<Object?> get props => [];
}

class ComingSoonInitial extends ComingSoonState {}

class ComingSoonLoading extends ComingSoonState {}

class ComingSoonLoaded extends ComingSoonState {
  final List<MovieModel> movies;
  final int currentPage;
  final int totalPages;
  final bool hasReachedMax;
  final bool isFetchingMore;

  const ComingSoonLoaded({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });

  ComingSoonLoaded copyWith({
    List<MovieModel>? movies,
    int? currentPage,
    int? totalPages,
    bool? hasReachedMax,
    bool? isFetchingMore,
  }) {
    return ComingSoonLoaded(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [
        movies,
        currentPage,
        totalPages,
        hasReachedMax,
        isFetchingMore,
      ];
}

class ComingSoonError extends ComingSoonState {
  final String message;

  const ComingSoonError({required this.message});

  @override
  List<Object?> get props => [message];
}
