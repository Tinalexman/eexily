enum OrderStatus {
  pending,
  completed,
}

class Order {
  final String id;
  final String code;
  final String address;
  final String deliveryIssue;
  final OrderStatus status;
  final DateTime deliveryDate;
  final String name;
  final String phone;

  final String riderImage;
  final String riderName;
  final String riderBike;

  final double price;


  const Order({
    this.id = "",
    this.code = "",
    this.address = "",
    this.deliveryIssue = "",
    this.status = OrderStatus.pending,
    required this.deliveryDate,
    this.name = "",
    this.phone = "",
    this.riderImage = "",
    this.riderName = "",
    this.riderBike = "",
    this.price = 0.0,
  });

}