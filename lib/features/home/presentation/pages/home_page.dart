import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:education/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:education/features/auth/domain/entities/user.dart';
import 'package:education/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final user = context.select<AuthBloc, User?>((bloc) => bloc.state.user);

    final name = user?.firstName ?? AppLocalizations.of(context)!.anonymousUser;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        elevation: 0,
        backgroundColor: theme.surface,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)!.weLcome}, $name!',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
            SizedBox(height: 24.h),

            // Example Card 1
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Icon(Icons.book, size: 32.sp, color: theme.primary),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.enrolledCourses,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: theme.onSurface)),
                        Text('5', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Example Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to Courses
                },
                icon: const Icon(Icons.play_arrow),
                label: Text(AppLocalizations.of(context)!.startLearning),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
