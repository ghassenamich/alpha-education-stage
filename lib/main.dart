import 'package:education/features/auth/presentation/bloc/login_bloc.dart';
import 'package:education/features/auth/presentation/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/service_locator.dart' as di;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => di.sl<LoginBloc>(),
        ),
        // Add other BLoCs here if needed later
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Clean Architecture App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(), // 👈 Your login screen
      ),
    );
  }
}
