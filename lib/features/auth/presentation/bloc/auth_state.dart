import 'package:equatable/equatable.dart';
import 'package:education/features/auth/domain/entities/user.dart';

class AuthState extends Equatable {
  final User? user;

  const AuthState({this.user});

  @override
  List<Object?> get props => [user];
}
