import 'package:education/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    required String type,
  }) : super(
         id: id,
         email: email,
         firstName: firstName,
         lastName: lastName,
         type: type,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('📦 UserModel.fromJson received: $json');

    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'type': type,
    };
  }
}
