import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netflix_clone_court/data/models/movie_model.dart';
import 'package:netflix_clone_court/data/models/movie_response.dart';
import 'package:netflix_clone_court/data/repositories/movie_repository.dart';
import 'package:netflix_clone_court/presentation/bloc/search/search_bloc.dart';
import 'package:netflix_clone_court/presentation/bloc/search/search_event.dart';
import 'package:netflix_clone_court/presentation/bloc/search/search_state.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late SearchBloc searchBloc;
  late MockMovieRepository mockMovieRepository;

  const tMovie = MovieModel(
    id: 2,
    title: 'Avatar',
    overview: 'Sci-fi epic',
    posterPath: '/avatar.jpg',
    voteAverage: 7.9,
  );

  const tMovieResponse = MovieResponse(
    page: 1,
    results: [tMovie],
    totalPages: 1,
    totalResults: 1,
  );

  const tEmptyResponse = MovieResponse(
    page: 1,
    results: [],
    totalPages: 1,
    totalResults: 0,
  );

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    searchBloc = SearchBloc(movieRepository: mockMovieRepository);
  });

  tearDown(() {
    searchBloc.close();
  });

  group('SearchBloc Tests', () {
    test('initial state should be SearchInitial', () {
      expect(searchBloc.state, SearchInitial());
    });

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, PopularSearchesLoaded] when LoadPopularSearches is added',
      build: () {
        when(() => mockMovieRepository.getPopularMovies())
            .thenAnswer((_) async => tMovieResponse);
        return searchBloc;
      },
      act: (bloc) => bloc.add(LoadPopularSearches()),
      expect: () => [
        SearchLoading(),
        const PopularSearchesLoaded(movies: [tMovie]),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchLoaded] when query returns results',
      build: () {
        when(() => mockMovieRepository.searchMovies(query: 'Avatar'))
            .thenAnswer((_) async => tMovieResponse);
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged(query: 'Avatar')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        const SearchLoaded(query: 'Avatar', movies: [tMovie]),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchEmpty] when query returns no results',
      build: () {
        when(() => mockMovieRepository.searchMovies(query: 'UnknownMovie'))
            .thenAnswer((_) async => tEmptyResponse);
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged(query: 'UnknownMovie')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        const SearchEmpty(query: 'UnknownMovie'),
      ],
    );
  });
}
