import '../entities/school_entity.dart';

abstract class TutorHistoryRepository {
  Future<List<SchoolEntity>> getTutorHistory();
}
