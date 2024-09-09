class Notification {
  final String message;
  final bool read;
  final DateTime timestamp;

  const Notification({
    this.message = "",
    this.read = false,
    required this.timestamp,
  });
}
