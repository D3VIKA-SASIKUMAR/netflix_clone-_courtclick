import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/movie_repository.dart';
import 'coming_soon_event.dart';
import 'coming_soon_state.dart';

class ComingSoonBloc extends Bloc<ComingSoonEvent, ComingSoonState> {
  final MovieRepository movieRepository;

  ComingSoonBloc({required this.movieRepository}) : super(ComingSoonInitial()) {
    on<FetchUpcomingMovies>(_onFetchUpcomingMovies);
    on<LoadMoreUpcomingMovies>(_onLoadMoreUpcomingMovies);
  }

  Future<void> _onFetchUpcomingMovies(
    FetchUpcomingMovies event,
    Emitter<ComingSoonState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(ComingSoonLoading());
    }

    try {
      final response = await movieRepository.getUpcomingMovies(page: 1);
      emit(
        ComingSoonLoaded(
          movies: response.results,
          currentPage: 1,
          totalPages: response.totalPages,
          hasReachedMax: response.page >= response.totalPages,
        ),
      );
    } catch (e) {
      emit(ComingSoonError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadMoreUpcomingMovies(
    LoadMoreUpcomingMovies event,
    Emitter<ComingSoonState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ComingSoonLoaded ||
        currentState.hasReachedMax ||
        currentState.isFetchingMore) {
      return;
    }

    emit(currentState.copyWith(isFetchingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final response = await movieRepository.getUpcomingMovies(page: nextPage);

      emit(
        currentState.copyWith(
          movies: [...currentState.movies, ...response.results],
          currentPage: nextPage,
          totalPages: response.totalPages,
          hasReachedMax: nextPage >= response.totalPages,
          isFetchingMore: false,
        ),
      );
    } catch (_) {
      emit(currentState.copyWith(isFetchingMore: false));
    }
  }
}
