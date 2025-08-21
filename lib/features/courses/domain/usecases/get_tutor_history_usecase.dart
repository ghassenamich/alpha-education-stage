import 'package:education/features/courses/domain/entities/school_entity.dart';
import '../repository/tutor_history_repository.dart';

class GetTutorHistoryUseCase {
  final TutorHistoryRepository repository;

  GetTutorHistoryUseCase(this.repository);

  Future<List<SchoolEntity>> call() {
    return repository.getTutorHistory();
  }
}
