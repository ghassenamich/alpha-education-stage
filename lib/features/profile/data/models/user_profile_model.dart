import 'package:education/features/profile/domain/entities/userprofile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    String? city,
    String? address,
    String? postalCode,
    String? birthdate,
    String? phone,
    String? gender,
    String? description,
    String? status,
    String? classe,
    String? badge,
    String? availabilityDate,
    String? preferredLanguage,
    required bool notificationsEnabled,
    String? avatarUrl,
  }) : super(
         id: id,
         firstName: firstName,
         lastName: lastName,
         email: email,
         city: city,
         address: address,
         postalCode: postalCode,
         birthdate: birthdate,
         phone: phone,
         gender: gender,
         description: description,
         status: status,
         classe: classe,
         badge: badge,
         availabilityDate: availabilityDate,
         preferredLanguage: preferredLanguage,
         notificationsEnabled: notificationsEnabled,
         avatarUrl: avatarUrl,
       );

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']['attributes']['user'];
    return UserProfileModel(
      id: user['id'],
      firstName: user['first_name'],
      lastName: user['last_name'],
      email: user['email'],
      city: user['city'],
      address: user['address'],
      postalCode: user['postal_code'],
      birthdate: user['birthdate'],
      phone: user['phone'],
      gender: user['gender'],
      description: user['description'],
      status: user['status'],
      classe: user['classe'],
      badge: user['badge'],
      availabilityDate: user['availability_date'],
      preferredLanguage: user['preferred_language'],
      notificationsEnabled: user['notifications_enabled'] ?? false,
      avatarUrl: json['data']['attributes']['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'city': city,
      'address': address,
      'postal_code': postalCode,
      'birthdate': birthdate,
      'phone': phone,
      'gender': gender,
      'description': description,
      'status': status,
      'classe': classe,
      'badge': badge,
      'availability_date': availabilityDate,
      'preferred_language': preferredLanguage,
      'notifications_enabled': notificationsEnabled,
      'avatar': avatarUrl,
    };
  }
}
