import 'package:education/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:education/features/auth/domain/entities/user.dart';
import 'package:education/features/auth/domain/repository/auth_repository.dart';
import 'package:education/core/util/session_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login({required String email, required String password}) async {
    final (userModel, headers) = await remoteDataSource.login(
      email: email,
      password: password,
    );

    await SessionStorage.saveSession(
      user: userModel,
      headers: headers,
    );
    print("✅ Saved session for user: ${userModel.email}");


    return userModel;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
