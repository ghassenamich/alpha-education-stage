import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:education/features/auth/domain/entities/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<SetUserEvent>((event, emit) {
      emit(AuthState(user: event.user));
    });

    on<ClearUserEvent>((event, emit) {
      emit(const AuthState());
    });
  }
}
