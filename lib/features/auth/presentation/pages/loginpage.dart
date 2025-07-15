import 'package:education/core/mainscaffold/main_scafold.dart';
import 'package:education/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:education/features/auth/presentation/bloc/auth_event.dart';
import 'package:education/features/auth/presentation/widgets/costumtextfieelds.dart';
import 'package:education/features/auth/presentation/widgets/customsnackbar.dart';
import 'package:education/core/localizations/widgets/languageselector.dart';
import 'package:education/features/auth/presentation/widgets/loginbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:education/config/themes/widget/theme_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

                showCustomSnackBar(
                  context: context,
                  message: message,
                  textColor: Theme.of(context).colorScheme.error,
                );
              }

              if (state is LoginSuccess) {
                showCustomSnackBar(
                  context: context,
                  message: AppLocalizations.of(context)!.loginSuccess,
                  textColor: Theme.of(context).colorScheme.primary,
                );

                final user = state.user;

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => AuthBloc()..add(SetUserEvent(user)),
                      child: const MainScaffold(),
                    ),
                  ),
                  (route) => false,
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
                      SizedBox(height: 70.h),
                      Text(
                        AppLocalizations.of(context)!.welcomeBack,
                        style: TextStyle(
                          fontFamily: 'roboto',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 150.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Image.asset(
                            'assets/images/image.png',
                            width: 200.w,
                            height: 200.h,
                          ),
                        ],
                      ),

                      // Email field
                      CustomTextField(
                        controller: emailController,
                        label: AppLocalizations.of(context)!.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.emailRequired;
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                          if (!emailRegex.hasMatch(value)) {
                            return AppLocalizations.of(context)!.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30.h),
                      CustomTextField(
                        controller: passwordController,
                        label: AppLocalizations.of(context)!.password,
                        isPassword: true,
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

                      SizedBox(height: 70.h),

                      // Login button
                      LoginButton(
                        onPressed: _onLoginPressed,
                        isLoading: state is LoginLoading,
                        label: AppLocalizations.of(context)!.log,
                      ),

                      SizedBox(height: 40.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const LanguageSelector(),
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: ThemeToggleButton(
                              size: 16.w,
                              icon: Icons.nightlight_round,
                              iconColor: Theme.of(context).colorScheme.primary,
                            ),
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
