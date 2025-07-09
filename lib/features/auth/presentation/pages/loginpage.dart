import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/bloc/local_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'package:education/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _onLoginPressed() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Dispatch login event
    context.read<LoginBloc>().add(
      LoginButtonPressed(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }

              if (state is LoginSuccess) {
                // You can navigate to another screen here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.loginSuccess),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 100),
                    Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary
                      ),
                    ),
                    const SizedBox(height: 70),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        cursorColor: Theme.of(context).colorScheme.primary,
                        controller: emailController,
                        decoration: 
                        
                        InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.email, 
                          focusColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: passwordController,
                        cursorColor: Theme.of(context).colorScheme.primary,
                        obscureText: true,
                        decoration:
                        InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.password,
                           // Use localization for password label
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    Container(
                      width: 200,
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 48, 48, 255),
                            Color.fromARGB(255, 70, 172, 255),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: _onLoginPressed,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          child: Center(
                            child: state is LoginLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.log,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    PopupMenuButton<Locale>(
                    icon: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
                    onSelected: (locale) {
                      context.read<LocaleBloc>().add(SetLocale(locale));
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: Locale('en'),
                        child: Text('English'),
                      ),
                      const PopupMenuItem(
                        value: Locale('fr'),
                        child: Text('Français'),
                      ),
                    ],
                    color: Theme.of(context).colorScheme.surface
                  ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
