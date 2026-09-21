import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/movie_response.dart';
import '../../../data/repositories/movie_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository movieRepository;

  HomeBloc({required this.movieRepository}) : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(HomeLoading());
    }

    try {
      const emptyResponse = MovieResponse(
        page: 1,
        results: [],
        totalPages: 1,
        totalResults: 0,
      );

      final popularRes = await movieRepository
          .getPopularMovies()
          .catchError((_) => emptyResponse);

      final trendingRes = await movieRepository
          .getTrendingMovies()
          .catchError((_) => popularRes);

      final nowPlayingRes = await movieRepository
          .getNowPlayingMovies()
          .catchError((_) => popularRes);

      final topRatedRes = await movieRepository
          .getTopRatedMovies()
          .catchError((_) => popularRes);

      final popularList = popularRes.results;
      final trendingList =
          trendingRes.results.isNotEmpty ? trendingRes.results : popularList;
      final nowPlayingList = nowPlayingRes.results.isNotEmpty
          ? nowPlayingRes.results
          : popularList;
      final topRatedList =
          topRatedRes.results.isNotEmpty ? topRatedRes.results : popularList;

      if (popularList.isEmpty && trendingList.isEmpty) {
        emit(
          const HomeError(
            message:
                'Network connection failed. Please check your network connection.',
          ),
        );
        return;
      }

      final featured =
          trendingList.isNotEmpty ? trendingList.first : popularList.first;

      emit(
        HomeLoaded(
          featuredMovie: featured,
          popularMovies: popularList,
          trendingMovies: trendingList,
          nowPlayingMovies: nowPlayingList,
          topRatedMovies: topRatedList,
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
