import 'package:education/features/profile/data/models/user_profile_model.dart';
import 'package:dio/dio.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> fetchProfile({
    required Map<String, String> headers,
    required String userType,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<UserProfileModel> fetchProfile({
    required Map<String, String> headers,
    required String userType,
  }) async {
    final response = await dio.get(
      '/api/v1/$userType/members_only',
      options: Options(headers: headers),
    );

    return UserProfileModel.fromJson(response.data);
  }
}
