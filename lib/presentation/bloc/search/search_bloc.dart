import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../data/repositories/movie_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepository movieRepository;

  SearchBloc({required this.movieRepository}) : super(SearchInitial()) {
    on<LoadPopularSearches>(_onLoadPopularSearches);
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 400)),
    );
  }

  Future<void> _onLoadPopularSearches(
    LoadPopularSearches event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final response = await movieRepository.getPopularMovies();
      emit(PopularSearchesLoaded(movies: response.results));
    } catch (e) {
      emit(SearchError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      add(LoadPopularSearches());
      return;
    }

    emit(SearchLoading());
    try {
      final response = await movieRepository.searchMovies(query: query);
      if (response.results.isEmpty) {
        emit(SearchEmpty(query: query));
      } else {
        emit(SearchLoaded(query: query, movies: response.results));
      }
    } catch (e) {
      emit(SearchError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
