import 'package:education/core/mainscaffold/main_scafold.dart';
import 'package:education/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:education/features/auth/presentation/bloc/auth_event.dart';
import 'package:education/features/auth/presentation/widgets/costumtextfieelds.dart';
import 'package:education/features/auth/presentation/widgets/customsnackbar.dart';
import 'package:education/core/localizations/widgets/languageselector.dart';
import 'package:education/features/auth/presentation/widgets/loginbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:education/config/themes/widget/theme_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/bloc/local_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      context.read<LoginBloc>().add(
        LoginButtonPressed(email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: theme.surface,
        systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.dark 
            ? Brightness.light 
            : Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark 
            ? Brightness.light 
            : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: theme.surface,
      body: Stack(
        children: [
          // Subtle background pattern
          CustomPaint(
            painter: DotPatternPainter(
              color: theme.primary.withOpacity(0.03),
              spacing: 50.0,
            ),
            size: Size.infinite,
          ),
          
          // Floating background elements
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.primary.withOpacity(0.08),
                    theme.primary.withOpacity(0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: -50.h,
            left: -50.w,
            child: Container(
              width: 150.w,
              height: 150.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.secondary.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Header with back button and controls
                _buildTopBar(),
                
                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginFailure) {
                          String message;
                          if (state.message == "Exception: Wrong email or password") {
                            message = '${AppLocalizations.of(context)!.loginfailed} ${AppLocalizations.of(context)!.wrongEmailOrPassword}';
                          } else if (state.message == 'Exception: unknown error : make sure you are connected to the internet') {
                            message = '${AppLocalizations.of(context)!.loginfailed} ${AppLocalizations.of(context)!.networkError}';
                          } else {
                            message = '${AppLocalizations.of(context)!.loginfailed} ${state.message}';
                          }

                          showCustomSnackBar(
                            context: context,
                            message: message,
                            textColor: theme.error,
                          );
                        }

                        if (state is LoginSuccess) {
                          showCustomSnackBar(
                            context: context,
                            message: AppLocalizations.of(context)!.loginSuccess,
                            textColor: theme.primary,
                          );

                          final user = state.user;
                          Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  BlocProvider(
                                    create: (_) => AuthBloc()..add(SetUserEvent(user)),
                                    child: const MainScaffold(),
                                  ),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                            (route) => false,
                          );
                        }
                      },
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 60.h),
                              
                              // Hero section
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: SlideTransition(
                                  position: _slideAnimation,
                                  child: _buildHeroSection(),
                                ),
                              ),
                              
                              SizedBox(height: 60.h),
                              
                              // Login form card
                              SlideTransition(
                                position: _slideAnimation,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: _buildLoginCard(state),
                                ),
                              ),
                              
                              SizedBox(height: 40.h),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    final theme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: theme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: theme.outline.withOpacity(0.1),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: theme.onSurface,
                  size: 18.sp,
                ),
              ),
            ),
          ),
          
          // Controls
          Row(
            children: [
              // Language selector
              Container(
                decoration: BoxDecoration(
                  color: theme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: theme.outline.withOpacity(0.1),
                  ),
                ),
                child: PopupMenuButton<Locale>(
                  icon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Icon(
                      Icons.language_rounded,
                      color: theme.onSurface,
                      size: 18.sp,
                    ),
                  ),
                  onSelected: (locale) {
                    context.read<LocaleBloc>().add(SetLocale(locale));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  color: theme.surface,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: const Locale('en'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🇺🇸', style: TextStyle(fontSize: 16.sp)),
                          SizedBox(width: 12.w),
                          Text('English', style: TextStyle(color: theme.onSurface)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: const Locale('fr'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🇫🇷', style: TextStyle(fontSize: 16.sp)),
                          SizedBox(width: 12.w),
                          Text('Français', style: TextStyle(color: theme.onSurface)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 12.w),
              
              // Theme toggle
              Container(
                decoration: BoxDecoration(
                  color: theme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: theme.outline.withOpacity(0.1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: ThemeToggleButton(
                    size: 18.w,
                    icon: Icons.brightness_6_rounded,
                    iconColor: theme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final theme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        // App icon
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: theme.primaryContainer,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.school_rounded,
            size: 60.sp,
            color: theme.primary,
          ),
        ),
        
        SizedBox(height: 24.h),
        
        // Welcome text
        Text(
          AppLocalizations.of(context)!.welcomeBack,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: theme.onSurface,
          ),
        ),
        
        SizedBox(height: 8.h),
        
        Text(
          'Sign in to continue your learning journey',
          style: TextStyle(
            fontSize: 15.sp,
            color: theme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(LoginState state) {
    final theme = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: theme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadow.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form fields
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
          
          SizedBox(height: 20.h),
          
          CustomTextField(
            controller: passwordController,
            label: AppLocalizations.of(context)!.password,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.passwordRequired;
              }
              if (value.length < 7) {
                return AppLocalizations.of(context)!.passwordTooShort;
              }
              return null;
            },
          ),
          
          SizedBox(height: 32.h),
          
          // Login button
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: state is LoginLoading ? null : _onLoginPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: theme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: state is LoginLoading
                  ? SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.onPrimary),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.log,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.login_rounded,
                          size: 20.sp,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for subtle dot pattern
class DotPatternPainter extends CustomPainter {
  final Color color;
  final double spacing;

  DotPatternPainter({
    required this.color,
    this.spacing = 50.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}