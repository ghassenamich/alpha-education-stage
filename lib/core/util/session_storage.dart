import 'dart:convert';
import 'package:education/features/profile/data/models/user_profile_model.dart';
import 'package:education/features/profile/domain/entities/userprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education/features/auth/domain/entities/user.dart';

class SessionStorage {
  static const _userKey = 'user_data';
  static const _headersKey = 'auth_headers';

  static Future<void> saveSession({
    required User user,
    required Map<String, String> headers,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
      _userKey,
      jsonEncode({
        'id': user.id,
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'type': user.type,
      }),
    );

    prefs.setString(_headersKey, jsonEncode(headers));
  }

  static Future<(User?, Map<String, String>?)> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userRaw = prefs.getString(_userKey);
    final headersRaw = prefs.getString(_headersKey);
    print("📦 Loaded user: $userRaw");
    print("📦 Loaded headers: $headersRaw");

    if (userRaw == null || headersRaw == null) return (null, null);

    final userMap = jsonDecode(userRaw);
    final headers = Map<String, String>.from(jsonDecode(headersRaw));

    final user = User(
      id: userMap['id'],
      email: userMap['email'],
      firstName: userMap['firstName'],
      lastName: userMap['lastName'],
      type: userMap['type'],
    );

    return (user, headers);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_headersKey);
  }

  static const _profileKey = 'user_profile';

  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _profileKey,
      jsonEncode((profile as UserProfileModel).toJson()),
    );
  }

  static Future<UserProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_profileKey);
    if (data == null) return null;
    return UserProfileModel.fromJson(jsonDecode(data));
  }
  }
