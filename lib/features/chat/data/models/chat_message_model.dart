import 'package:education/features/chat/domain/entities/message_entity.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.conversationId,
    required super.time,
    required super.user,
    required super.sender,
    required super.content,
    required super.attachments,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final attr = json['attributes'];
    return MessageModel(
      id: json['id'],
      conversationId: attr['conversation_id'],
      time: attr['time'],
      user: attr['user'],
      sender: attr['sender'],
      content: attr['content'],
      attachments: List<dynamic>.from(attr['attachments']),
    );
  }
}
