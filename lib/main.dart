import 'package:education/config/themes/bloc/theme_bloc.dart';
import 'package:education/config/themes/bloc/theme_state.dart';
import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/bloc/local_state.dart';
import 'package:education/core/mainscaffold/main_scafold.dart';
import 'package:education/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:education/features/auth/presentation/bloc/auth_event.dart';
import 'package:education/features/auth/presentation/cubit/session_startup_cubit.dart';
import 'package:education/features/auth/presentation/pages/mainpage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:education/features/auth/presentation/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // <-- Import this
import 'di/service_locator.dart' as di;
import 'config/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
                    home: BlocBuilder<SessionStartupCubit, SessionState>(
                      builder: (context, state) {
                        if (state is SessionChecking) {
                          return Scaffold(
                            body: Center(
                              child: Container(
                                width: 384.w,
                                color: Theme.of(context).colorScheme.surface,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      AppLocalizations.of(context)!.checkingSession,
                                      style: TextStyle(fontSize: 18, fontFamily: "roboto", color: Theme.of(context).colorScheme.onSurface),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (state is SessionValid) {
                          context.read<AuthBloc>().add(
                            SetUserEvent(state.user),
                          );
                          return MainScaffold();
                        } else {
                          return const Mainpage(); // login button is here
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
