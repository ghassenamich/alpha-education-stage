import 'package:education/features/chat/domain/entities/message_entity.dart';
import 'package:education/features/chat/domain/usecases/get_chat_messages.dart';
import 'package:education/features/chat/domain/usecases/get_conversation.dart';
import 'package:education/features/chat/presentation/cupit/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetConversations getConversations;
  final GetMessages getMessages;

  int? _conversationId; // store the ID internally

  ChatCubit({required this.getConversations, required this.getMessages})
    : super(ChatInitial());

  Future<void> loadChat() async {
    emit(ChatLoading());
    try {
      // fetch the support conversation
      final conversations = await getConversations();
      if (conversations.isNotEmpty) {
        _conversationId = conversations.first.id; // already int ✅
        await loadMessages();
      } else {
        emit(ChatError("No conversation found"));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> loadMessages() async {
    if (_conversationId == null) {
      emit(ChatError("No conversation ID available"));
      return;
    }

    emit(ChatLoading());
    try {
      final List<Message> allMessages = [];
      int page = 1;
      bool hasMore = true;

      while (hasMore) {
        final messages = await getMessages(
          _conversationId!.toString(),
          page: page,
        );
        if (messages.isEmpty) {
          hasMore = false;
        } else {
          allMessages.addAll(messages);
          page++;
        }
      }

      emit(ChatLoaded(allMessages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
