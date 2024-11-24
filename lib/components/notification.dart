class Notification {
  final String message;
  final bool read;
  final DateTime timestamp;
  final String actionLabel;
  final String notificationType;

  const Notification({
    this.message = "",
    this.read = false,
    this.actionLabel = "",
    this.notificationType = "",
    required this.timestamp,
  });

  factory Notification.fromJson(Map<String, dynamic> map) {
    return Notification(
      timestamp: DateTime.parse(map["createdAt"]),
      message: map["message"],
      read: map["read"] ?? false,
      actionLabel: map["actionLabel"] ?? "New Notification",
      notificationType: map["notificationType"] ?? "",
    );
  }
}
