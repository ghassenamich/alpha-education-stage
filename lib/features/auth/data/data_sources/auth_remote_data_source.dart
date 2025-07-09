import 'package:dio/dio.dart';
import '../models/user_model.dart';


/// Contract for remote authentication calls.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/api/v1/auth/sign_in',
        data: {'email': email, 'password': password},
      );

      final raw = response.data;
      print("Raw response: $raw");

      if (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>) {
        final userJson = raw['data'] as Map<String, dynamic>;
        print("✅ Passing to UserModel: $userJson");
        return UserModel.fromJson(userJson);
      }

      throw Exception('Login failed: "data" field missing or invalid');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('NO_INTERNET_CONNECTION');
      }

      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        throw Exception('Wrong email or password');
      }

      throw Exception('unknown error : make sure you are connected to the internet');
    }
  }
}
