import 'package:dio/dio.dart';
import 'package:education/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:education/features/chat/data/repositories/chat_repository_imp.dart';
import 'package:education/features/chat/domain/usecases/get_chat_messages.dart';
import 'package:education/features/chat/domain/usecases/get_conversation.dart';
import 'package:education/features/chat/presentation/cupit/chat_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:education/config/themes/bloc/theme_bloc.dart';
import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/data/locale_repository.dart';

import 'package:education/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:education/features/auth/data/repository/auth_repository_impl.dart';
import 'package:education/features/auth/domain/repository/auth_repository.dart';
import 'package:education/features/auth/domain/usecases/login_user.dart';
import 'package:education/features/auth/presentation/bloc/login_bloc.dart';
import 'package:education/features/auth/presentation/cubit/session_startup_cubit.dart';

import 'package:education/features/profile/data/data_sources/profile_remote_data_source.dart';

import 'package:education/features/courses/data/data_sources/tutor_history_remote_datasource.dart';
import 'package:education/features/courses/data/repository/tutor_history_repository_impl.dart';
import 'package:education/features/courses/domain/repository/tutor_history_repository.dart';
import 'package:education/features/courses/domain/usecases/get_tutor_history_usecase.dart';
import 'package:education/features/courses/presentation/cubit/tutor_history_cubit.dart';

import 'package:education/features/chat/domain/repositories/chat_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // -------- LOCALE & THEME --------
  sl.registerLazySingleton<LocaleRepository>(
    () => LocaleRepository(prefs: sl()),
  );
  sl.registerLazySingleton<LocaleBloc>(
    () => LocaleBloc(localeRepository: sl()),
  );

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

  sl.registerLazySingleton<ThemeBloc>(() => ThemeBloc());

  // -------- AUTH --------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerFactory(() => LoginBloc(loginUser: sl()));
  sl.registerLazySingleton(() => SessionStartupCubit(sl()));

  // -------- PROFILE --------
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl<Dio>()),
  );

  // -------- COURSES --------
  sl.registerLazySingleton<TutorHistoryRemoteDataSource>(
    () => TutorHistoryRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<TutorHistoryRepository>(
    () => TutorHistoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetTutorHistoryUseCase(sl()));
  sl.registerFactory(() => TutorHistoryCubit(sl()));

// -------- CHAT --------

sl.registerLazySingleton<http.Client>(() => http.Client());

// Remote DataSource
sl.registerLazySingleton<ChatRemoteDataSource>(
  () => ChatRemoteDataSourceImpl(sl<http.Client>()),
);

// Repository
sl.registerLazySingleton<ChatRepository>(
  () => ChatRepositoryImpl(sl<ChatRemoteDataSource>()),
);

// Usecases
sl.registerLazySingleton(() => GetConversations(sl<ChatRepository>()));
sl.registerLazySingleton(() => GetMessages(sl<ChatRepository>()));

// Cubit
sl.registerFactory(
  () => ChatCubit(
    getConversations: sl<GetConversations>(),
    getMessages: sl<GetMessages>(),
  ),
);



}
