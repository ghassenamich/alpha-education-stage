import 'package:education/config/themes/widget/theme_button.dart';
import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/bloc/local_event.dart';
import 'package:education/features/auth/presentation/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.9, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          // Background with subtle pattern
          Container(
            decoration: BoxDecoration(
              color: theme.surface,
              image: DecorationImage(
                image: const AssetImage('assets/images/pattern.png'),
                fit: BoxFit.cover,
                opacity: 0.03,
                colorFilter: ColorFilter.mode(
                  theme.primary.withOpacity(0.1),
                  BlendMode.overlay,
                ),
              ),
            ),
          ),
          
          // Floating shapes
          Positioned(
            top: 100.h,
            right: -50.w,
            child: Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.primary.withOpacity(0.1),
                    theme.primary.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: 200.h,
            left: -80.w,
            child: Container(
              width: 150.w,
              height: 150.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.secondary.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Column(
                  children: [
                    // Header section
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildHeader(),
                    ),
                    
                    // Main content area
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 40.h),
                            
                            // Hero image/icon
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: _buildHeroSection(),
                            ),
                            
                            SizedBox(height: 60.h),
                            
                            // Text content
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildTextContent(),
                              ),
                            ),
                            
                            SizedBox(height: 80.h),
                            
                            // CTA Button
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildCTAButton(),
                              ),
                            ),
                            
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App logo/title
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: theme.primaryContainer,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_rounded,
                  color: theme.onPrimaryContainer,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'EduApp',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          
          // Settings buttons
          Row(
            children: [
              _buildHeaderButton(
                icon: Icons.language_rounded,
                onTap: () => _showLanguageDialog(),
              ),
              SizedBox(width: 12.w),
              _buildHeaderButton(
                icon: Icons.brightness_6_rounded,
                onTap: () {}, // Theme toggle handled by ThemeToggleButton
                child: ThemeToggleButton(
                  size: 20.w,
                  icon: Icons.brightness_6_rounded,
                  iconColor: theme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
    Widget? child,
  }) {
    final theme = Theme.of(context).colorScheme;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: theme.outline.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadow.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child ?? Icon(
            icon,
            color: theme.onSurfaceVariant,
            size: 20.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    final theme = Theme.of(context).colorScheme;
    
    return Container(
      width: 280.w,
      height: 280.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primary.withOpacity(0.1),
            theme.secondary.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 200.w,
          height: 200.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: theme.primary.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Icon(
            Icons.auto_stories_rounded,
            size: 100.sp,
            color: theme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    final theme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        // Welcome badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: theme.secondaryContainer,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            AppLocalizations.of(context)!.welcome,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: theme.onSecondaryContainer,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        SizedBox(height: 24.h),
        
        // Main title
        Text(
          AppLocalizations.of(context)!.mobileApp,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.w800,
            color: theme.onSurface,
            height: 1.2,
          ),
        ),
        
        SizedBox(height: 20.h),
        
        // Description
        Container(
          constraints: BoxConstraints(maxWidth: 300.w),
          child: Text(
            AppLocalizations.of(context)!.start,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: theme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCTAButton() {
    final theme = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 300.w),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primary,
          foregroundColor: theme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 18.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.getStarted,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_rounded,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    final theme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Select Language',
          style: TextStyle(
            color: theme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('🇺🇸', 'English', const Locale('en')),
            SizedBox(height: 8.h),
            _buildLanguageOption('🇫🇷', 'Français', const Locale('fr')),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String flag, String language, Locale locale) {
    final theme = Theme.of(context).colorScheme;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<LocaleBloc>().add(SetLocale(locale));
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Text(flag, style: TextStyle(fontSize: 24.sp)),
              SizedBox(width: 16.w),
              Text(
                language,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: theme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}