import 'package:education/config/themes/bloc/theme_bloc.dart';
import 'package:education/config/themes/bloc/theme_state.dart';
import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/bloc/local_state.dart';
import 'package:education/core/mainscaffold/main_scafold.dart';
import 'package:education/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:education/features/auth/presentation/bloc/auth_event.dart';
import 'package:education/features/auth/presentation/cubit/session_startup_cubit.dart';
import 'package:education/features/auth/presentation/pages/mainpage.dart';
import 'package:education/features/chat/presentation/cupit/chat_cubit.dart';
import 'package:education/features/courses/presentation/cubit/tutor_history_cubit.dart';
import 'package:education/features/courses/presentation/pages/LessonDetailPage.dart';
import 'package:education/features/courses/presentation/pages/cours_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:education/features/auth/presentation/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // <-- Added
import 'di/service_locator.dart' as di;
import 'config/themes/themes.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); // <-- Added

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => di.sl<LoginBloc>()),
        BlocProvider<LocaleBloc>(create: (_) => di.sl<LocaleBloc>()),
        BlocProvider<ThemeBloc>(create: (_) => di.sl<ThemeBloc>()),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<SessionStartupCubit>(
          create: (_) => di.sl<SessionStartupCubit>()..checkSession(),
        ),
        BlocProvider(
          create: (context) => di.sl<TutorHistoryCubit>()..loadTutorHistory(),
          child: TutorHistoryPage(),
        ),
        BlocProvider<ChatCubit>(create: (_) => di.sl<ChatCubit>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              return ScreenUtilInit(
                designSize: Size(384, 805),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Alpha Education',
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: themeState.themeMode,
                    locale: localeState.locale,
                    supportedLocales: const [Locale('en'), Locale('fr')],
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    routes: {
                      '/lesson_detail': (context) => const LessonDetailPage(),
                    },
                    home: BlocBuilder<SessionStartupCubit, SessionState>(
                      builder: (context, state) {
                        if (state is! SessionChecking) {
                          FlutterNativeSplash.remove(); // <-- Added
                        }

                        if (state is SessionChecking) {
                          return Scaffold(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/image.png',
                                    width: 200.w,
                                    height: 200.w,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 24.h),
                                  CircularProgressIndicator(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is SessionValid) {
                          context.read<AuthBloc>().add(
                            SetUserEvent(state.user),
                          );
                          return MainScaffold();
                        } else {
                          return const Mainpage();
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
