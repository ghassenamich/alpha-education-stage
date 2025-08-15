import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/student_entity.dart';

class LessonModel extends LessonEntity {
  LessonModel({
    required super.id,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.realDate,
    required super.groupName,
    required super.students,
    super.schoolName,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    final course = json['course'];
    final group = json['real_group'];
    final List<dynamic> studentsJson = group['students'] ?? [];

    return LessonModel(
      id: json['id'],
      date: json['real_date'], // this is the French "Jeu 30 mai 2024"
      realDate: json['real_date'],
      startTime: course['start_at'],
      endTime: course['end_at'],
      groupName: group['name'] ?? '-',
      schoolName:
          json['school_name'], // optional, fallback to "-" if null in UI
      students: studentsJson
          .map(
            (s) => StudentEntity(
              id: s['id'],
              firstName: s['first_name'],
              lastName: s['last_name'],
              classe: s['classe'],
              hasReport: s['has_report']?.toString().toLowerCase() == 'true',
              isPresent: s['is_present']?.toString().toLowerCase() == 'true',
            ),
          )
          .toList(),
    );
  }
}
