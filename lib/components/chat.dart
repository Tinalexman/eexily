class Conversation {
  final String id;
  final String? image;
  final bool active;
  final String name;
  final String lastMessage;
  final DateTime timestamp;
  final int messageCount;
  final String? code;

  const Conversation({
    this.id = "",
    this.code,
    this.image,
    this.active = false,
    this.name = "",
    this.lastMessage = "",
    required this.timestamp,
    this.messageCount = 0,
  });
}


class Message {
  final String message;
  final String sender;
  final DateTime timestamp;

  const Message({
    this.message = "",
    this.sender = "",
    required this.timestamp,
  });
}