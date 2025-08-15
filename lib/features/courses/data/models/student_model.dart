import '../../domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  const StudentModel({
    required int id,
    required String firstName,
    required String lastName,
    required String classe,
    required bool hasReport,
    required bool isPresent,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          classe: classe,
          hasReport: hasReport,
          isPresent: isPresent,
        );

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      classe: json['classe'] ?? '',
      hasReport: (json['has_report']?.toString().toLowerCase() == 'true'),
      isPresent: (json['is_present']?.toString().toLowerCase() == 'true'),
    );
  }
}
