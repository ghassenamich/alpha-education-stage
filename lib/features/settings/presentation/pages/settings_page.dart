import 'package:education/config/themes/bloc/theme_bloc.dart';
import 'package:education/config/themes/bloc/theme_event.dart';
import 'package:education/config/themes/bloc/theme_state.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:education/core/localizations/widgets/languageselector.dart';
import 'package:education/features/auth/domain/usecases/logout_user.dart';
import 'package:education/features/auth/data/repository/auth_repository_impl.dart';
import 'package:education/di/service_locator.dart';
import 'package:education/features/auth/presentation/pages/loginpage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final logout = LogoutUser(AuthRepositoryImpl(sl()));
    await logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.surface,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        children: [
          // Settings Section Header
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 12.h),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: theme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Settings Card Container
          Container(
            decoration: BoxDecoration(
              color: theme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: theme.outline,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // 🔠 Language Option
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: theme.primaryContainer,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.language, color: theme.primary, size: 20.sp),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.languages,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: theme.onSurface,
                    ),
                  ),
                  trailing: const LanguageSelector(iconData: Icons.arrow_drop_down),
                  onTap: () {
                    // Navigate to language screen or show dialog
                  },
                ),

                Divider(height: 1, indent: 68.w, endIndent: 20.w),

                // 🌙 Dark Mode Toggle
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    final isDarkMode = themeState.themeMode == ThemeMode.dark;
                    
                    return SwitchListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                      secondary: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: theme.primaryContainer,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: theme.primary,
                          size: 20.sp,
                        ),
                      ),
                      title: Text(
                        isDarkMode ? 'Dark Mode' : 'Light Mode',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.onSurface,
                        ),
                      ),
                      value: isDarkMode,
                      onChanged: (value) {
                        context.read<ThemeBloc>().add(ToggleTheme());
                      },
                      activeColor: theme.primary,
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // About Section Header
          Padding(
            padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
            child: Text(
              'Information',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: theme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // About Card
          Container(
            decoration: BoxDecoration(
              color: theme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: theme.outline,
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              leading: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: theme.primaryContainer,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.info_outline, color: theme.primary, size: 20.sp),
              ),
              title: Text(
                AppLocalizations.of(context)!.about,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.onSurface,
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: theme.onSurfaceVariant),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: theme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.welcome,
                      style: TextStyle(
                        color: theme.primary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: theme.primaryContainer,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              color: theme.primary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          AppLocalizations.of(context)!.appdescription,
                          style: TextStyle(
                            color: theme.onSurface,
                            fontSize: 15.sp,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.primary,
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        ),
                        child: Text(
                          MaterialLocalizations.of(context).closeButtonLabel,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 32.h),

          // Logout Button with improved styling
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: OutlinedButton.icon(
              onPressed: () => _logout(context),
              icon: Icon(Icons.logout, color: theme.error, size: 20.sp),
              label: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(
                  color: theme.error,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'roboto',
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.error, width: 1.5),
                minimumSize: Size(double.infinity, 52.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}