import 'package:education/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:education/features/auth/domain/entities/user.dart';
import 'package:education/features/auth/domain/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDataSource.login(email: email, password: password);
    return userModel;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // or prefs.remove('accessToken');
  }
}
