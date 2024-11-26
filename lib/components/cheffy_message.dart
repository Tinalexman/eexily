
const String userRole = "user";
const String systemRole = "system";
const String assistantRole = "assistant";

class CheffyMessage {
  final String role;
  final String content;
  final DateTime timestamp;

  const CheffyMessage({
    required this.timestamp,
    required this.role,
    required this.content,
  });

  factory CheffyMessage.fromJson(Map<String, dynamic> map) {
    return CheffyMessage(
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["timestamp"]),
      role: map["role"],
      content: map["content"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "content": content,
    };
  }
}
