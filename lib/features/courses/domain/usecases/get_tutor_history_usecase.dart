import '../entities/lesson_entity.dart';
import '../repository/tutor_history_repository.dart';

class GetTutorHistoryUseCase {
  final TutorHistoryRepository repository;

  GetTutorHistoryUseCase(this.repository);

  Future<List<LessonEntity>> call() {
    return repository.getTutorHistory();
  }
}
