import 'package:education/features/chat/domain/entities/conversation_entity.dart';

class ConversationModel extends Conversation {
  ConversationModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'];
    return ConversationModel(
      id: int.parse(json['id']), // <-- FIXED
      name: attrs['name'],
      createdAt: DateTime.parse(attrs['created_at']),
      updatedAt: DateTime.parse(attrs['updated_at']),
    );
  }
}
