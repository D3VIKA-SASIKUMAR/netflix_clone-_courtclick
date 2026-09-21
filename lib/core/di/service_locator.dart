import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../data/datasources/tmdb_api_service.dart';
import '../../data/repositories/movie_repository.dart';
import '../../presentation/bloc/home/home_bloc.dart';
import '../../presentation/bloc/search/search_bloc.dart';
import '../../presentation/bloc/coming_soon/coming_soon_bloc.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<TMDBApiService>(
    () => TMDBApiServiceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(apiService: getIt<TMDBApiService>()),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(movieRepository: getIt<MovieRepository>()),
  );
  getIt.registerFactory<SearchBloc>(
    () => SearchBloc(movieRepository: getIt<MovieRepository>()),
  );
  getIt.registerFactory<ComingSoonBloc>(
    () => ComingSoonBloc(movieRepository: getIt<MovieRepository>()),
  );
}
