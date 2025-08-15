import 'package:education/features/courses/presentation/widgerts/lesson_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../cubit/tutor_history_cubit.dart';

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
              final lessons = state.lessons;

              if (lessons.isEmpty) {
                return Center(
                  child: Text(
                    loc.noLessons,
                    style: TextStyle(color: theme.primary),
                  ),
                );
              }

              return ListView.separated(
                itemCount: lessons.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final lesson = lessons[index];

                  return Padding(
                    padding: EdgeInsets.all(8.w),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 384.w),
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
