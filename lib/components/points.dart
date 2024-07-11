class PointsSaved {
  final String image;
  final String name;
  final int gas;
  final int belly;

  const PointsSaved({
    required this.image,
    required this.name,
    required this.gas,
    required this.belly,
  });
}

enum PointType { gas, belly }

enum PointTransactionType { earned, expired }

class PointsTransaction {
  final PointType pointType;
  final PointTransactionType transactionType;
  final int amount;
  final int total;
  final DateTime timestamp;

  const PointsTransaction({
    required this.pointType,
    required this.transactionType,
    this.amount = 0,
    this.total = 0,
    required this.timestamp,
  });
}
