import 'package:dio/dio.dart';
import '../models/user_model.dart';

/// Contract for remote authentication calls.
abstract class AuthRemoteDataSource {

  Future<UserModel> login({
    required String email,
    required String password,
  });
}

/// Concrete Dio-based implementation.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/api/v1/auth/sign_in',
      data: {
        'email': email,
        'password': password,
      },
    );

    final json = response.data;
    if (json is Map<String, dynamic> && json.containsKey('data')) {
      return UserModel.fromJson(json['data'] as Map<String, dynamic>);
    }

    return UserModel.fromJson(json as Map<String, dynamic>);
  }
}
