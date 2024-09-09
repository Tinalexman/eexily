import 'order.dart';

class SaleReport {
  final String id;
  final double retailPrice;
  final double regularPrice;
  final DateTime timestamp;
  final List<Order> orders;

  const SaleReport({
    this.id = "",
    this.regularPrice = 0.0,
    this.retailPrice = 0.0,
    required this.timestamp,
    this.orders = const [],
  });
}
