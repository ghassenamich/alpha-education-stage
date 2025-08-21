import 'package:flutter/material.dart';
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

class _TutorHistoryPageState extends State<TutorHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<TutorHistoryCubit>().loadTutorHistory();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          loc.tutorHistoryTitle,
          style: const TextStyle(fontFamily: 'roboto'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: BlocBuilder<TutorHistoryCubit, TutorHistoryState>(
          builder: (context, state) {
            if (state is TutorHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TutorHistoryLoaded) {
              final schools = state.schools;

              if (schools.isEmpty) {
                return Center(
                  child: Text(
                    loc.noLessons,
                    style: TextStyle(color: theme.primary),
                  ),
                );
              }

              return ListView.builder(
                itemCount: schools.length,
                itemBuilder: (context, index) {
                  final SchoolEntity school = schools[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // School header
                        Text(
                          school.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.primary,
                          ),
                        ),
                        if (school.postalCode != null)
                          Text(
                            school.postalCode!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: theme.primary.withOpacity(0.7),
                            ),
                          ),
                        SizedBox(height: 12.h),

                        // Lessons list under this school
                        ...school.lessons.map((lesson) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: LessonCard(
                              lesson: lesson,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/lesson_detail',
                                  arguments: lesson,
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              );
            }

            if (state is TutorHistoryError) {
              return Center(
                child: Text(
                  loc.errorLoadingLessons,
                  style: TextStyle(color: theme.error),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
