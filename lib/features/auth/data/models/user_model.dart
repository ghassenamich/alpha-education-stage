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
    final data = json['data'];

    return UserModel(
      id: data['id'],
      email: data['email'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      type: data['type'],
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
