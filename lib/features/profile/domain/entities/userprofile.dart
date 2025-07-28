class UserProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? city;
  final String? address;
  final String? postalCode;
  final String? birthdate;
  final String? phone;
  final String? gender;
  final String? description;
  final String? status;
  final String? classe;
  final String? badge;
  final String? availabilityDate;
  final String? preferredLanguage;
  final bool notificationsEnabled;
  final String? avatarUrl;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.city,
    this.address,
    this.postalCode,
    this.birthdate,
    this.phone,
    this.gender,
    this.description,
    this.status,
    this.classe,
    this.badge,
    this.availabilityDate,
    this.preferredLanguage,
    required this.notificationsEnabled,
    this.avatarUrl,
  });
}
