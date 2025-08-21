import 'package:dio/dio.dart';
import '../models/school_model.dart';

abstract class TutorHistoryRemoteDataSource {
  Future<List<SchoolModel>> fetchTutorHistory({
    required Map<String, String> headers,
    required String userType,
  });
}

class TutorHistoryRemoteDataSourceImpl implements TutorHistoryRemoteDataSource {
  final Dio dio;

  TutorHistoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<SchoolModel>> fetchTutorHistory({
    required Map<String, String> headers,
    required String userType,
  }) async {
    final response = await dio.get(
      "/api/v1/tutor/me/history",
      options: Options(headers: headers),
    );

    // API returns a list of schools inside "data"
    final List<dynamic> schoolsJson = response.data["data"];

    return schoolsJson
        .map((schoolJson) => SchoolModel.fromJson(schoolJson))
        .toList();
  }
}
