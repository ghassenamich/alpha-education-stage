import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:education/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:education/features/auth/domain/entities/user.dart';
import 'package:education/l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthBloc, User?>((bloc) => bloc.state.user);
    final theme = Theme.of(context).colorScheme;

    if (user == null) {
      return const Center(child: Text("User data not loaded."));
    }

    final fullName =
        '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48.r,
                  backgroundColor: theme.primary,
                  child: Icon(Icons.person, size: 48.r, color: theme.onPrimary),
                ),
                SizedBox(height: 12.h),
                Text(
                  fullName.isNotEmpty ? fullName : AppLocalizations.of(context)!.anonymousUser,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  user.email,
                  style: TextStyle(
                    color: theme.primary,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          ListTile(
            leading: Icon(Icons.badge, color: theme.primary),
            title: Text(AppLocalizations.of(context)!.userType, 
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: theme.primary,
              ),
            ),
            subtitle: Text(user.type, 
              style: TextStyle(
                color: theme.primary,
                fontSize: 16.sp,
              ),
            ),
          ),

          Divider(height: 32.h),

          OutlinedButton.icon(
            onPressed: () {
              // Trigger logout if needed
            },
            icon: Icon(Icons.logout, color: theme.primary),
            label: Text(
              AppLocalizations.of(context)!.logout,
              style: TextStyle(color: theme.primary),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.primary),
              minimumSize: Size(double.infinity, 48.h),
            ),
          ),
        ],
      ),
    );
  }
}
