import 'package:education/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:education/features/auth/data/repository/auth_repository_impl.dart';
import 'package:education/features/auth/domain/repository/auth_repository.dart';
import 'package:education/features/auth/domain/usecases/login_user.dart';
import 'package:education/features/auth/presentation/bloc/login_bloc.dart';
import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/data/locale_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ✅ SharedPreferences (must be awaited)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // ✅ LocaleRepository (depends on SharedPreferences)
  sl.registerLazySingleton<LocaleRepository>(
    () => LocaleRepository(prefs: sl()),
  );

  // ✅ LocaleBloc with repository injected
  sl.registerLazySingleton<LocaleBloc>(
    () => LocaleBloc(localeRepository: sl()),
  );

  // Dio client
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: 'http://staging.alphaeducation.fr',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));

  // Blocs
  sl.registerFactory(() => LoginBloc(loginUser: sl()));
}
