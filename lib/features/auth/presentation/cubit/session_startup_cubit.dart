import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:education/core/util/session_storage.dart';
import 'package:education/features/auth/domain/entities/user.dart';

abstract class SessionState {}

class SessionChecking extends SessionState {}

class SessionValid extends SessionState {
  final User user;
  SessionValid(this.user);
}

class SessionInvalid extends SessionState {}

class SessionStartupCubit extends Cubit<SessionState> {
  final Dio dio;

  SessionStartupCubit(this.dio) : super(SessionChecking());

  Future<void> checkSession() async {
    final (user, headers) = await SessionStorage.loadSession();

    if (user == null || headers == null) {
      emit(SessionInvalid());
      return;
    }

    try {
      print("🔁 Validating with URL: /api/v1/${user.type}/validate");
      print("🔐 Headers being sent: $headers");

      final response = await dio.get(
        '/api/v1/${user.type}/members_only',
        options: Options(headers: headers),
      );

      print("📨 Response status: ${response.statusCode}");
      print("📨 Response data: ${response.data}");

      if (response.statusCode == 200) {
        emit(SessionValid(user));
      } else {
        print("❌ Validation failed, clearing session");
        await SessionStorage.clear();
        emit(SessionInvalid());
      }
    } catch (e) {
      print("⚠️ Exception during validation: $e");
      await SessionStorage.clear();
      emit(SessionInvalid());
    }
  }
}
