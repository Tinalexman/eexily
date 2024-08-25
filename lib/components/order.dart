enum OrderStatus {
  pending,
  completed,
}

class Order {
  final String code;
  final String address;
  final String deliveryIssue;
  final OrderStatus status;
  final DateTime deliveryDate;
  final String name;
  final String phone;
  final double cylinderSize;

  final String? riderImage;
  final String riderName;
  final String riderBike;


  const Order({
    this.code = "",
    this.address = "",
    this.deliveryIssue = "",
    this.status = OrderStatus.pending,
    required this.deliveryDate,
    this.name = "",
    this.phone = "",
    this.cylinderSize = 0.0,
    this.riderImage,
    this.riderName = "",
    this.riderBike = "",
  });

}