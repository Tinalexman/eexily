import 'order.dart';

class SaleReport {
  final String id;
  final DateTime timestamp;
  final List<Order> orders;

  const SaleReport({
    this.id = "",
    required this.timestamp,
    this.orders = const [],
  });
}
