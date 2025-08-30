import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:education/features/courses/domain/entities/lesson_entity.dart';
import 'package:education/l10n/app_localizations.dart';

class LessonCard extends StatefulWidget {
  final LessonEntity lesson;
  final VoidCallback onTap;

  const LessonCard({super.key, required this.lesson, required this.onTap});

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverStart() {
    if (!_isHovered) {
      setState(() => _isHovered = true);
      _hoverController.forward();
    }
  }

  void _onHoverEnd() {
    if (_isHovered) {
      setState(() => _isHovered = false);
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final formattedDate = _getFormattedDate(widget.lesson.realDate, loc.localeName);
    final formattedTime = '${widget.lesson.startTime ?? ''} - ${widget.lesson.endTime ?? ''}';

    return Semantics(
      label: 'Lesson card for ${widget.lesson.groupName} on $formattedDate',
      child: Hero(
        tag: 'lesson_${widget.lesson.id}',
        child: Material(
          type: MaterialType.transparency,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: MouseRegion(
                  onEnter: (_) => _onHoverStart(),
                  onExit: (_) => _onHoverEnd(),
                  child: GestureDetector(
                    onTapDown: (_) => _onHoverStart(),
                    onTapUp: (_) => _onHoverEnd(),
                    onTapCancel: () => _onHoverEnd(),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onTap();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.surface,
                            theme.surface.withOpacity(0.95),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: _isHovered 
                              ? theme.primary.withOpacity(0.3)
                              : theme.primary.withOpacity(0.1),
                          width: _isHovered ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primary.withOpacity(_isHovered ? 0.15 : 0.08),
                            blurRadius: _isHovered ? 20 : 12,
                            offset: Offset(0, _isHovered ? 8 : 4),
                          ),
                          BoxShadow(
                            color: theme.surface.withOpacity(0.8),
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header with date and status indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.primary.withOpacity(0.1),
                                          theme.secondary.withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: theme.primary.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: theme.primary,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.primary,
                                        theme.secondary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.primary.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    color: theme.surface,
                                    size: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            // Time section
                            _buildInfoRow(
                              Icons.access_time_rounded,
                              formattedTime,
                              theme,
                            ),
                            
                            SizedBox(height: 12.h),
                            
                            // School section
                            if (widget.lesson.schoolName != null &&
                                widget.lesson.schoolName!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: _buildInfoRow(
                                  Icons.school_rounded,
                                  widget.lesson.schoolName!,
                                  theme,
                                ),
                              ),
                            
                            // Group section
                            _buildInfoRow(
                              Icons.groups_rounded,
                              '${loc.groupLabel}: ${widget.lesson.groupName}',
                              theme,
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            // Footer with student count and action indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.primaryContainer.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: theme.primary.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.people_outline_rounded,
                                        size: 14.sp,
                                        color: theme.primary,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        '${widget.lesson.students.length} students',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: theme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedRotation(
                                  duration: const Duration(milliseconds: 200),
                                  turns: _isHovered ? 0.1 : 0.0,
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: theme.primary.withOpacity(_isHovered ? 0.15 : 0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14.sp,
                                      color: theme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, ColorScheme theme) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: theme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: theme.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: theme.onSurface,
              height: 1.2,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
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