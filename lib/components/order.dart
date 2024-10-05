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

enum OrderState { pickedUp, refilled, dispatched, delivered }

class OrderDeliveryData {
  final DateTime timestamp;
  final OrderState state;

  const OrderDeliveryData({
    required this.state,
    required this.timestamp,
  });
}

class UserOrder {
  final List<OrderDeliveryData> states;
  final String username;
  final String code;
  final String id;
  final int price;
  final int gasAmount;

  const UserOrder({
    this.states = const [],
    this.username = "",
    this.code = "",
    this.id = "",
    this.price = 0,
    this.gasAmount = 0,
  });
}
