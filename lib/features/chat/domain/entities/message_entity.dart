class Message {
  final String id;
  final int conversationId;
  final String time;
  final String user;
  final String sender; // "me" or "other"
  final String content;
  final List<dynamic> attachments;

  Message({
    required this.id,
    required this.conversationId,
    required this.time,
    required this.user,
    required this.sender,
    required this.content,
    required this.attachments,
  });
}
