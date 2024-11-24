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

enum OrderState {
  pending,
  matched,
  paid,
  pickedUp,
  refilled,
  dispatched,
  delivered,
  nil,
}

OrderState convertState(String state) {
  switch(state) {
    case "PENDING": return OrderState.pending;
    case "MATCHED": return OrderState.matched;
    case "PAID": return OrderState.paid;
    case "PICK_UP": return OrderState.pickedUp;
    case "REFILL": return OrderState.refilled;
    case "DISPATCHED": return OrderState.dispatched;
    case "DELIVERED": return OrderState.delivered;
    default: return OrderState.nil;
  }
}

class OrderStates {
  final OrderState state;
  final String timestamp;

  const OrderStates({
    required this.state,
    required this.timestamp,
  });
}

class UserOrder {
  final String id;
  final String code;
  final double price;
  final String status;
  final int quantity;
  final String sellerType;
  final String pickedUpTime;
  final String paymentMethod;
  final String scheduledTime;
  final String address;
  final String location;
  final String paymentUrl;
  final String reference;
  final List<OrderStates> states;

  const UserOrder({
    this.states = const [],
    this.id = "",
    this.paymentUrl = "",
    this.reference = "",
    this.location = "",
    this.code = "",
    this.sellerType = "",
    this.address = "",
    this.price = 0.0,
    this.quantity = 0,
    this.status = "",
    this.paymentMethod = "",
    this.pickedUpTime = "",
    this.scheduledTime = "",
  });
}
