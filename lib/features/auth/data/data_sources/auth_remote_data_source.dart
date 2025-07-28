import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<(UserModel, Map<String, String>)> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<(UserModel, Map<String, String>)> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/api/v1/auth/sign_in',
        data: {'email': email, 'password': password},
      );

      final raw = response.data;
      if (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>) {
        final userJson = raw['data'] as Map<String, dynamic>;
        final userModel = UserModel.fromJson(userJson);

        final headers = {
          'uid': response.headers.value('uid') ?? '',
          'client': response.headers.value('client') ?? '',
          'access-token': response.headers.value('access-token') ?? '',
        };

        return (userModel, headers);
      }

      throw Exception('Login failed: "data" field missing or invalid');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('NO_INTERNET_CONNECTION');
      }

      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        throw Exception('Wrong email or password');
      }

      throw Exception('unknown error');
    }
  }

  
}
