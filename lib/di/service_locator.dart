
import 'package:education/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:education/features/auth/data/repository/auth_repository_impl.dart';
import 'package:education/features/auth/domain/repository/auth_repository.dart';
import 'package:education/features/auth/domain/usecases/login_user.dart';
import 'package:education/features/auth/presentation/bloc/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';



final sl = GetIt.instance;

Future<void> init() async {
  // Dio client
  sl.registerLazySingleton(() => Dio(BaseOptions(
    baseUrl: 'http://staging.alphaeducation.fr', // ← Replace with your real base URL
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  )));

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));

  // Bloc
  sl.registerFactory(() => LoginBloc(loginUser: sl()));
}
