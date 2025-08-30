import 'package:education/features/chat/domain/entities/message_entity.dart';
import 'package:education/features/chat/domain/repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;
  GetMessages(this.repository);

  Future<List<Message>> call(String conversationId, {int page = 1}) {
    return repository.getMessages(conversationId, page: page);
  }
}
