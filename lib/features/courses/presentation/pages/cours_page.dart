import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/school_entity.dart';
import '../cubit/tutor_history_cubit.dart';
import '../widgerts/lesson_card.dart';

class TutorHistoryPage extends StatefulWidget {
  const TutorHistoryPage({super.key});

  @override
  State<TutorHistoryPage> createState() => _TutorHistoryPageState();
}

class _TutorHistoryPageState extends State<TutorHistoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
    context.read<TutorHistoryCubit>().loadTutorHistory();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 1.0],
            colors: [
              theme.onSurface.withOpacity(0.05),
              theme.primaryContainer.withOpacity(0.08),
              theme.surface,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Modern App Bar
            _buildModernAppBar(theme, loc),
            
            // Content
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(theme, loc),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernAppBar(ColorScheme theme, AppLocalizations loc) {
    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: theme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: theme.primary.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: theme.onPrimary,
              size: 20.sp,
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: theme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: theme.primary.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            loc.tutorHistoryTitle,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: theme.onPrimary,
            ),
          ),
        ),
        centerTitle: true,
        titlePadding: EdgeInsets.only(bottom: 16.h),
      ),
    );
  }

  Widget _buildContent(ColorScheme theme, AppLocalizations loc) {
    return BlocBuilder<TutorHistoryCubit, TutorHistoryState>(
      builder: (context, state) {
        if (state is TutorHistoryLoading) {
          return _buildLoadingState(theme);
        }

        if (state is TutorHistoryLoaded) {
          final schools = state.schools;

          if (schools.isEmpty) {
            return _buildEmptyState(theme, loc);
          }

          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                ...schools.asMap().entries.map((entry) {
                  int index = entry.key;
                  SchoolEntity school = entry.value;
                  
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    curve: Curves.easeOutBack,
                    child: _buildSchoolSection(school, theme, index),
                  );
                }).toList(),
                SizedBox(height: 40.h),
              ],
            ),
          );
        }

        if (state is TutorHistoryError) {
          return _buildErrorState(theme, loc);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSchoolSection(SchoolEntity school, ColorScheme theme, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // School header with modern styling
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primary.withOpacity(0.1),
                  theme.secondary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: theme.primary.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primary,
                            theme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: theme.surface,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            school.name,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.onPrimary,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          if (school.postalCode != null) ...[
                            SizedBox(height: 4.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                school.postalCode!,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: theme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: theme.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "${school.lessons.length} lessons",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // Lessons list with staggered animation
          ...school.lessons.asMap().entries.map((lessonEntry) {
            int lessonIndex = lessonEntry.key;
            final lesson = lessonEntry.value;
            
            return AnimatedContainer(
              duration: Duration(milliseconds: 200 + (lessonIndex * 50)),
              curve: Curves.easeOut,
              child: Container(
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primary.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: LessonCard(
                  lesson: lesson,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(
                      context,
                      '/lesson_detail',
                      arguments: lesson,
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme theme) {
    return Container(
      height: 400.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primary,
                    theme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Center(
                child: SizedBox(
                  width: 32.w,
                  height: 32.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.surface),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Loading your lesson history...",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.sp,
                color: theme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme theme, AppLocalizations loc) {
    return Container(
      height: 400.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primary.withOpacity(0.2),
                    theme.secondary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(60.r),
              ),
              child: Icon(
                Icons.history_edu_rounded,
                size: 60.sp,
                color: theme.primary,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              "No Lessons Yet",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: theme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              constraints: BoxConstraints(maxWidth: 280.w),
              child: Text(
                loc.noLessons,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15.sp,
                  color: theme.onSurface.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ColorScheme theme, AppLocalizations loc) {
    return Container(
      height: 400.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: theme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40.sp,
                color: theme.error,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Oops! Something went wrong",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: theme.error,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              loc.errorLoadingLessons,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14.sp,
                color: theme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}