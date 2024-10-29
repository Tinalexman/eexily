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
  final int gasQuantity;

  const Order({
    this.id = "",
    this.gasQuantity = 0,
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


class UserOrder {
  final String orderState;
  final String id;
  final String code;
  final double price;
  final int quantity;

  const UserOrder({
    this.orderState = "PENDING",
    this.id = "",
    this.code = "",
    this.price = 0.0,
    this.quantity = 0,
  });
}
