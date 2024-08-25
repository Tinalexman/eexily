class Conversation {
  final String id;
  final String image;
  final bool active;
  final String name;
  final String lastMessage;
  final DateTime timestamp;
  final int messageCount;

  const Conversation({
    this.id = "",
    this.image = "",
    this.active = false,
    this.name = "",
    this.lastMessage = "",
    required this.timestamp,
    this.messageCount = 0,
  });
}
