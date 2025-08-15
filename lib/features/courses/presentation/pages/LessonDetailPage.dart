import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:education/l10n/app_localizations.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/student_entity.dart';

class LessonDetailPage extends StatelessWidget {
  const LessonDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final lesson = ModalRoute.of(context)!.settings.arguments as LessonEntity;

    final formattedDate = _formatLessonDate(lesson.realDate, loc.localeName);
    final formattedTime = '${lesson.startTime ?? ''} - ${lesson.endTime ?? ''}';

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        title: Text(
          loc.lessonDetails,
          style: const TextStyle(fontFamily: 'roboto'),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Instructions banner
          SliverToBoxAdapter(
            child: Container(
              color: theme.primary,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Text(
                loc.lessonInstructions,
                style: TextStyle(color: theme.onPrimary, fontSize: 14.sp),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),

          // Fixed Hero section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Hero(
                tag: 'lesson_${lesson.id}',
                child: Material(
                  color: Colors.transparent,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            lesson.schoolName ?? "-",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              color: theme.primary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: theme.primary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: theme.primary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          const Divider(),
                          SizedBox(height: 8.h),
                          Text(
                            '${loc.groupLabel}: ${lesson.groupName}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: theme.primary,
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Students list header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                loc.studentsList,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: theme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Students list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final student = lesson.students[index];
                return _buildStudentRow(context, student, theme);
              },
              childCount: lesson.students.length,
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        ],
      ),
    );
  }

  String _formatLessonDate(String? rawDate, String locale) {
    if (rawDate == null || rawDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat.yMMMMEEEEd(locale).format(date);
    } catch (_) {
      return rawDate;
    }
  }

  Widget _buildStudentRow(
    BuildContext context,
    StudentEntity student,
    ColorScheme theme,
  ) {
    final loc = AppLocalizations.of(context)!;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      title: Text(
        '${student.lastName} ${student.firstName}',
        style: TextStyle(color: theme.primary, fontSize: 16.sp),
      ),
      subtitle: Text(
        '${loc.classLabel}: ${student.classe}',
        style: TextStyle(color: theme.primary, fontSize: 14.sp),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (student.hasReport)
            Icon(Icons.article, color: theme.primary, size: 20.r),
          if (student.isPresent)
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.check_circle, color: Colors.green, size: 20.r),
            ),
        ],
      ),
    );
  }
}
