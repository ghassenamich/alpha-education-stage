import 'package:education/features/chat/domain/entities/conversation_entity.dart';
import 'package:education/features/chat/domain/repositories/chat_repository.dart';

class GetConversations {
  final ChatRepository repository;
  GetConversations(this.repository);

  Future<List<Conversation>> call() {
    return repository.getConversations();
  }
}

