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
}
