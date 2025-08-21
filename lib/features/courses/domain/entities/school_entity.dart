import 'package:education/features/courses/domain/entities/lesson_entity.dart';

class SchoolEntity {
  final String id;
  final String name;
  final List<LessonEntity> lessons;
  final String? postalCode;

  SchoolEntity({
    required this.id,
    required this.name,
    required this.lessons,
    required this.postalCode,
  });
}
