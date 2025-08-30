import 'package:education/features/chat/domain/entities/conversation_entity.dart';
import 'package:education/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<List<Conversation>> getConversations();  
  Future<List<Message>> getMessages(String conversationId, {int page = 1});
}
