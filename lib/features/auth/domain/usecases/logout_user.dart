
import 'package:education/features/auth/domain/repository/auth_repository.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
