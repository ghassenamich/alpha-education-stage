

import 'package:education/features/auth/domain/entities/user.dart';

abstract class AuthRepository {

   Future<void> logout();

   
  Future<User> login({
    required String email,
    required String password,
  });
}
