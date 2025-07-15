import 'package:education/features/settings/presentation/widgets/theme_toggle_tile.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:education/core/localizations/widgets/languageselector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // 🔠 Language Option
          ListTile(
            leading: Icon(Icons.language, color: theme.primary),
            title: Text(
              AppLocalizations.of(context)!.languages,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: theme.primary,
              ),
            ),
            trailing: const LanguageSelector(iconData: Icons.arrow_drop_down),
            onTap: () {
              // Navigate to language screen or show dialog
            },
          ),

          Divider(),

          // 🌙 Dark Mode Toggle
          ThemeToggleTile(),

          Divider(),

          // 🔔 Notification Switch
          SwitchListTile(
            secondary: Icon(Icons.notifications_active, color: theme.primary),
            title: Text(
              AppLocalizations.of(context)!.notifications,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: theme.primary,
              ),
            ),
            value: true, // Replace with actual value from settings
            onChanged: (value) {
              // Save notification preference
            },
          ),

          Divider(),

          // ℹ️ About
          ListTile(
            leading: Icon(Icons.info_outline, color: theme.primary),
            title: Text(
              AppLocalizations.of(context)!.about,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: theme.primary,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              final theme = Theme.of(context).colorScheme;

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: theme.surface,
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
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: theme.primary,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        AppLocalizations.of(context)!.appdescription,
                        style: TextStyle(
                          color: theme.primary,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        MaterialLocalizations.of(context).closeButtonLabel,
                        style: TextStyle(color: theme.primary),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Divider(),

          SizedBox(height: 30.h),
          OutlinedButton.icon(
            onPressed: () {
              // Log out logic
            },
            icon: const Icon(Icons.logout),
            label: Text(AppLocalizations.of(context)!.logout),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
            ),
          ),
        ],
      ),
    );
  }
}
