import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/bloc/local_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:education/config/themes/widget/theme_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onLoginPressed() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginButtonPressed(email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                String message;
                if (state.message == "Exception: Wrong email or password") {
                  message =
                      '${AppLocalizations.of(context)!.loginfailed} ${AppLocalizations.of(context)!.wrongEmailOrPassword}';
                } else if (state.message ==
                    'Exception: unknown error : make sure you are connected to the internet') {
                  message =
                      '${AppLocalizations.of(context)!.loginfailed} ${AppLocalizations.of(context)!.networkError}';
                } else {
                  message =
                      '${AppLocalizations.of(context)!.loginfailed} ${state.message}';
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    content: Text(
                      message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                );
              }

              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    content: Text(
                      AppLocalizations.of(context)!.loginSuccess,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 100),
                      Text(
                        AppLocalizations.of(context)!.login,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 70),

                      // Email field
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.email,
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(
                                context,
                              )!.emailRequired;
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                            if (!emailRegex.hasMatch(value)) {
                              return AppLocalizations.of(context)!.invalidEmail;
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Password field
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.password,
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(
                                context,
                              )!.passwordRequired;
                            }
                            if (value.length < 7) {
                              return AppLocalizations.of(
                                context,
                              )!.passwordTooShort;
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 70),

                      // Login button
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
                                      style: const TextStyle(
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

                      // Language selector + Theme toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PopupMenuButton<Locale>(
                            icon: Icon(
                              Icons.language,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onSelected: (locale) {
                              context.read<LocaleBloc>().add(SetLocale(locale));
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: const Locale('en'),
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: const Locale('fr'),
                                child: Text(
                                  'Français',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: ThemeToggleButton(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
