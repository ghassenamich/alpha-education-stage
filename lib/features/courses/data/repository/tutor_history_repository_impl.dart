import 'package:education/core/util/session_storage.dart';
import 'package:education/features/courses/data/models/school_model.dart';
import 'package:education/features/courses/domain/entities/school_entity.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repository/tutor_history_repository.dart';
import '../data_sources/tutor_history_remote_datasource.dart';
import '../models/lesson_model.dart';

class TutorHistoryRepositoryImpl implements TutorHistoryRepository {
  final TutorHistoryRemoteDataSource remoteDataSource;

  TutorHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SchoolEntity>> getTutorHistory() async {
    final (storedUser, headers) = await SessionStorage.loadSession();
    if (storedUser == null || headers == null) return [];

    String usert = storedUser.type;
    if (usert == "schoolagent") usert = "school_agent";

    final List<SchoolModel> rawLessons = await remoteDataSource.fetchTutorHistory(
      userType: usert,
      headers: headers,
    );

    return rawLessons; // List<LessonModel> can be returned as List<LessonEntity>
  }
}
