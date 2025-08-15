import 'student_entity.dart';

class LessonEntity {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final String realDate;
  final String? schoolName;
  final String groupName;
  final List<StudentEntity> students;

  LessonEntity({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.realDate,
    required this.groupName,
    required this.students,
    this.schoolName,
  });
}
