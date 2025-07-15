import 'package:equatable/equatable.dart';
import 'package:education/features/auth/domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SetUserEvent extends AuthEvent {
  final User user;

  const SetUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class ClearUserEvent extends AuthEvent {}
