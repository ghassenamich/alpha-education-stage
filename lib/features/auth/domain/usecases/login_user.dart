import 'package:education/features/auth/domain/repository/auth_repository.dart';

import 'package:education/features/auth/domain/entities/user.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
