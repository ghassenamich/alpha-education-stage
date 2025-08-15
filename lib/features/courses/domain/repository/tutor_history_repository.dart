import '../entities/lesson_entity.dart';

abstract class TutorHistoryRepository {
  Future<List<LessonEntity>> getTutorHistory();
}
