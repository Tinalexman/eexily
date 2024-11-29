class OrderMetadata {
  final String pickUpAddress;
  final String pickUpLocation;

  final String userName;
  final String userPhoneNumber;

  final String riderName;
  final String riderPhoneNumber;

  final String gasStationName;
  final String gasStationAddress;
  final String gasStationLocation;

  final String merchantName;
  final String merchantAddress;
  final String merchantLocation;
  final String merchantPhoneNumber;

  const OrderMetadata({
    this.gasStationName = "",
    this.gasStationAddress = "",
    this.gasStationLocation = "",
    this.merchantAddress = "",
    this.merchantName = "",
    this.merchantLocation = "",
    this.merchantPhoneNumber = "",
    this.pickUpAddress = "",
    this.pickUpLocation = "",
    this.riderName = "",
    this.riderPhoneNumber = "",
    this.userName = "",
    this.userPhoneNumber = "",
  });
}

enum OrderState {
  pending,
  matched,
  paid,
  pickedUp,
  refilled,
  delivered,
  canceled,
  nil,
}

OrderState convertState(String state) {
  switch (state) {
    case "PENDING":
      return OrderState.pending;
    case "MATCHED":
      return OrderState.matched;
    case "PAID":
      return OrderState.paid;
    case "PICK_UP":
      return OrderState.pickedUp;
    case "REFILL":
      return OrderState.refilled;
    case "DELIVERED":
      return OrderState.delivered;
    default:
      return OrderState.nil;
  }
}

String convertStringState(OrderState state) {
  switch(state) {
    case OrderState.pending: return "PENDING";
    case OrderState.matched: return "MATCHED";
    case OrderState.paid: return "PAID";
    case OrderState.pickedUp: return "PICK_UP";
    case OrderState.refilled: return "REFILL";
    case OrderState.delivered: return "DELIVERED";
    case OrderState.canceled: return "CANCELED";
    default: return "";
  }
}

bool canProceedTo(String previousAction, String intendingAction) {
  switch(intendingAction) {
    case "PICK_UP": return previousAction == "PAID";
    case "REFILL": return previousAction == "PICK_UP";
    case "DELIVERED": return previousAction == "REFILL";
    default: return false;
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

class Order {
  final String id;
  final String code;
  final double price;
  final String status;
  final String createdAt;
  final int quantity;
  final String sellerType;
  final String paymentMethod;
  final String paymentUrl;
  final String reference;
  final List<OrderStates> states;
  final OrderMetadata metadata;

  const Order({
    this.states = const [],
    this.id = "",
    this.createdAt = "",
    this.paymentUrl = "",
    this.reference = "",
    this.code = "",
    this.sellerType = "",
    this.price = 0.0,
    this.quantity = 0,
    this.status = "",
    this.paymentMethod = "",
    this.metadata = const OrderMetadata(),
  });

  Order copyWith({
    String? id,
    String? code,
    double? price,
    String? status,
    int? quantity,
    String? sellerType,
    String? paymentMethod,
    String? paymentUrl,
    String? reference,
    String? createdAt,
    List<OrderStates>? states,
    OrderMetadata? metadata,
  }) {
    return Order(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      code: code ?? this.code,
      price: price ?? this.price,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      sellerType: sellerType ?? this.sellerType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      reference: reference ?? this.reference,
      states: states ?? this.states,
      metadata: metadata ?? this.metadata,
    );
  }
}
