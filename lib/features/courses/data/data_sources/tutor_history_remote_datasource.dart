import 'package:dio/dio.dart';
import '../models/lesson_model.dart';

abstract class TutorHistoryRemoteDataSource {
  Future<List<LessonModel>> fetchTutorHistory({
    required Map<String, String> headers,
    required String userType,
  });
}

class TutorHistoryRemoteDataSourceImpl implements TutorHistoryRemoteDataSource {
  final Dio dio;

  TutorHistoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<LessonModel>> fetchTutorHistory({
    required Map<String, String> headers,
    required String userType,
  }) async {
   

    final response = await dio.get(
      "/api/v1/tutor/me/history",
      options: Options(
        headers: headers,
      ),
    );

    final List<dynamic> lessonsJson =
        response.data["data"][0]["attributes"]["real_weeks_history"];

    return lessonsJson
        .map((lessonJson) => LessonModel.fromJson(lessonJson))
        .toList();
  }
}
