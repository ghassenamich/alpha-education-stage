class StudentEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String classe;
  final bool hasReport;
  final bool isPresent;

  const StudentEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.classe,
    required this.hasReport,
    required this.isPresent,
  });
}
