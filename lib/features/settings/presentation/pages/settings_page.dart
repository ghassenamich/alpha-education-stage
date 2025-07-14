import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // 🔠 Language Option
          ListTile(
            leading: Icon(Icons.language, color: theme.primary),
            title: Text(
              'Language',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: theme.primary,
              ),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to language screen or show dialog
            },
          ),

          Divider(),

          // 🌙 Dark Mode Toggle
          SwitchListTile(
            secondary: Icon(Icons.dark_mode, color: theme.primary),
            title: Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: theme.primary,
              ),
            ),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              // Trigger your ThemeBloc or toggle method
            },
          ),

          Divider(),

          // 🔔 Notification Switch
          SwitchListTile(
            secondary: Icon(Icons.notifications_active, color: theme.primary),
            title: Text(
              'Notifications',
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
            title: Text('About'
            ,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: theme.primary,
              ),),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to about page
            },
          ),

          Divider(),

          // 🚪 Log out
          SizedBox(height: 30.h),
          OutlinedButton.icon(
            onPressed: () {
              // Log out logic
            },
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
            ),
          ),
        ],
      ),
    );
  }
}
