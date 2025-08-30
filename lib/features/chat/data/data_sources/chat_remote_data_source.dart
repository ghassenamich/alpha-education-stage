import 'dart:convert';
import 'package:education/features/chat/data/models/chat_message_model.dart';
import 'package:education/features/chat/data/models/conversation_model.dart';
import 'package:http/http.dart' as http;
import 'package:education/core/util/session_storage.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations();

  Future<List<MessageModel>> getMessages(String conversationId, {int page = 1});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  ChatRemoteDataSourceImpl(this.client);

  @override
  Future<List<ConversationModel>> getConversations() async {
    final (storedUser, headers) = await SessionStorage.loadSession();
    final response = await client.get(
      Uri.parse('http://staging.alphaeducation.fr/api/v1/tutor/conversations'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return (decoded['data'] as List)
          .map((json) => ConversationModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load conversations");
    }
  }

  @override
  Future<List<MessageModel>> getMessages(
    String conversationId, {
    int page = 1,
  }) async {
    final (storedUser, headers) = await SessionStorage.loadSession();
    final response = await client.get(
      Uri.parse(
        'http://staging.alphaeducation.fr/api/v1/tutor/conversations/$conversationId/messages?page=$page',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return (decoded['data'] as List)
          .map((json) => MessageModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load messages");
    }
  }
}
