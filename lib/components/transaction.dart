class Transaction {
  final String id;
  final bool credit;
  final double amount;
  final DateTime timestamp;
  final String header;

  const Transaction({
    this.id = "",
    this.credit = false,
    this.amount = 0,
    required this.timestamp,
    this.header = "",
  });
}