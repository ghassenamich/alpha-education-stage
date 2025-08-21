part of 'tutor_history_cubit.dart';

abstract class TutorHistoryState {}

class TutorHistoryInitial extends TutorHistoryState {}

class TutorHistoryLoading extends TutorHistoryState {}

class TutorHistoryLoaded extends TutorHistoryState {
  final List<SchoolEntity> schools;  // ✅ was lessons before
  TutorHistoryLoaded(this.schools);
}

class TutorHistoryError extends TutorHistoryState {
  final String message;
  TutorHistoryError(this.message);
}
