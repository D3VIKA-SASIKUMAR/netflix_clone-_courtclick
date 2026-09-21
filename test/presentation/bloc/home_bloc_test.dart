import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netflix_clone_court/data/models/movie_model.dart';
import 'package:netflix_clone_court/data/models/movie_response.dart';
import 'package:netflix_clone_court/data/repositories/movie_repository.dart';
import 'package:netflix_clone_court/presentation/bloc/home/home_bloc.dart';
import 'package:netflix_clone_court/presentation/bloc/home/home_event.dart';
import 'package:netflix_clone_court/presentation/bloc/home/home_state.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late HomeBloc homeBloc;
  late MockMovieRepository mockMovieRepository;

  const tMovie = MovieModel(
    id: 1,
    title: 'Test Movie',
    overview: 'Test Overview',
    posterPath: '/test_poster.jpg',
    backdropPath: '/test_backdrop.jpg',
    voteAverage: 8.5,
  );

  const tMovieResponse = MovieResponse(
    page: 1,
    results: [tMovie],
    totalPages: 1,
    totalResults: 1,
  );

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    homeBloc = HomeBloc(movieRepository: mockMovieRepository);
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc Tests', () {
    test('initial state should be HomeInitial', () {
      expect(homeBloc.state, HomeInitial());
    });

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] when FetchHomeData is successful',
      build: () {
        when(() => mockMovieRepository.getTrendingMovies())
            .thenAnswer((_) async => tMovieResponse);
        when(() => mockMovieRepository.getPopularMovies())
            .thenAnswer((_) async => tMovieResponse);
        when(() => mockMovieRepository.getNowPlayingMovies())
            .thenAnswer((_) async => tMovieResponse);
        when(() => mockMovieRepository.getTopRatedMovies())
            .thenAnswer((_) async => tMovieResponse);
        return homeBloc;
      },
      act: (bloc) => bloc.add(const FetchHomeData()),
      expect: () => [
        HomeLoading(),
        const HomeLoaded(
          featuredMovie: tMovie,
          popularMovies: [tMovie],
          trendingMovies: [tMovie],
          nowPlayingMovies: [tMovie],
          topRatedMovies: [tMovie],
        ),
      ],
      verify: (_) {
        verify(() => mockMovieRepository.getTrendingMovies()).called(1);
        verify(() => mockMovieRepository.getPopularMovies()).called(1);
        verify(() => mockMovieRepository.getNowPlayingMovies()).called(1);
        verify(() => mockMovieRepository.getTopRatedMovies()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when repository throws error',
      build: () {
        when(() => mockMovieRepository.getTrendingMovies())
            .thenThrow(Exception('Network connection failed.'));
        when(() => mockMovieRepository.getPopularMovies())
            .thenThrow(Exception('Network connection failed.'));
        when(() => mockMovieRepository.getNowPlayingMovies())
            .thenThrow(Exception('Network connection failed.'));
        when(() => mockMovieRepository.getTopRatedMovies())
            .thenThrow(Exception('Network connection failed.'));
        return homeBloc;
      },
      act: (bloc) => bloc.add(const FetchHomeData()),
      expect: () => [
        HomeLoading(),
        const HomeError(message: 'Network connection failed.'),
      ],
    );
  });
}
