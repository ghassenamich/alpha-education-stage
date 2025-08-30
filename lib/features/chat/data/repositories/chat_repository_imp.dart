import 'package:education/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:education/features/chat/domain/entities/conversation_entity.dart';
import 'package:education/features/chat/domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Conversation>> getConversations() {
    return remoteDataSource.getConversations();
  }

  @override
  Future<List<Message>> getMessages(String conversationId, {int page = 1}) {
    return remoteDataSource.getMessages(conversationId, page: page);
  }
}
