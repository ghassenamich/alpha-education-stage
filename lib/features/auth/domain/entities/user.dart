class User {
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String type;

  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    required this.type,
  });
}
