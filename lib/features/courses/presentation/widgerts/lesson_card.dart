import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:education/features/courses/domain/entities/lesson_entity.dart';
import 'package:education/l10n/app_localizations.dart';

class LessonCard extends StatelessWidget {
  final LessonEntity lesson;
  final VoidCallback onTap;

  const LessonCard({super.key, required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final formattedDate = _getFormattedDate(lesson.realDate, loc.localeName);
    final formattedTime = '${lesson.startTime ?? ''} - ${lesson.endTime ?? ''}';

    return Semantics(
      label: 'Lesson card for ${lesson.groupName} on $formattedDate',
      child: Hero(
        tag: 'lesson_${lesson.id}',
        child: Material(
          type: MaterialType.transparency,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(12.r),
                    splashColor: theme.primary.withOpacity(0.1),
                    highlightColor: Colors.transparent,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: theme.onSurface,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadow.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: theme.primary,
                              fontFamily: 'roboto',
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16.r,
                                color: theme.primary,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: theme.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          if (lesson.schoolName != null &&
                              lesson.schoolName!.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  Icons.school,
                                  size: 16.r,
                                  color: theme.primary,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    lesson.schoolName!,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: theme.primary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(Icons.group,
                                  size: 16.r, color: theme.primary),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  '${loc.groupLabel}: ${lesson.groupName}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: theme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getFormattedDate(String? rawDate, String localeName) {
    if (rawDate == null || rawDate.isEmpty) return '-';
    final parts = rawDate.trim().split(RegExp(r'\s+'));
    if (parts.length < 4) return rawDate;

    const monthMap = {
      "janv": 1, "févr": 2, "fevr": 2, "mars": 3, "avr": 4, "mai": 5,
      "juin": 6, "juil": 7, "août": 8, "aout": 8, "sept": 9,
      "oct": 10, "nov": 11, "déc": 12, "dec": 12,
    };

    try {
      final day = int.parse(parts[1]);
      final rawMonth = parts[2].replaceAll('.', '').toLowerCase();
      final month = monthMap[rawMonth] ?? 0;
      final year = int.parse(parts[3]);
      if (month == 0) return rawDate;

      final date = DateTime(year, month, day);

      final weekdaysEn = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      final weekdaysFr = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
      final monthsEn = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ];
      final monthsFr = [
        "janv", "févr", "mars", "avr", "mai", "juin",
        "juil", "août", "sept", "oct", "nov", "déc"
      ];

      final isFrench = localeName.startsWith("fr");
      final weekday = isFrench
          ? weekdaysFr[date.weekday - 1]
          : weekdaysEn[date.weekday - 1];
      final monthName = isFrench
          ? monthsFr[month - 1]
          : monthsEn[month - 1];

      return "$weekday ${day.toString().padLeft(2, '0')} $monthName $year";
    } catch (_) {
      return rawDate;
    }
  }
}
