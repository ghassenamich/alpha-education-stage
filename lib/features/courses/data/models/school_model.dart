import '../../domain/entities/school_entity.dart';
import 'lesson_model.dart';

class SchoolModel extends SchoolEntity {
  SchoolModel({
    required super.id,
    required super.name,
    required super.lessons,
    required super.postalCode,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] ?? {};
    final lessonsJson = attrs['real_weeks_history'] as List? ?? [];

    return SchoolModel(
      id: json['id'].toString(),
      name: attrs['name'] ?? 'Unknown School',
      lessons: lessonsJson.map((l) => LessonModel.fromJson(l)).toList(),
      postalCode: attrs['postal_code'] as String?,

    );
  }
}
