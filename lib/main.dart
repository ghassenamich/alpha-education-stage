import 'package:education/config/themes/bloc/theme_bloc.dart';
import 'package:education/config/themes/bloc/theme_state.dart';
import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/bloc/local_state.dart';
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
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              return ScreenUtilInit(
                designSize: Size(
                  384,
                  805,
                ), // Your base design size (e.g., iPhone X)
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
                    home: const Mainpage(),
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
