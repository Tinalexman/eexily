import "package:eexily/components/order.dart";

import "base.dart";

Future<EexilyResponse<UserOrder?>> createScheduledOrder(
    Map<String, dynamic> map) async {
  try {
    Response response = await dio.post(
      "/refill-schedule",
      data: map,
      options: configuration,
    );

    if (response.statusCode! == 200) {
      Map<String, dynamic> data = response.data["payload"];
      return EexilyResponse(
        message: "Gas Refill Scheduled",
        payload: data["gcode"],
        status: true,
      );
    }
  } on DioException catch (e) {
    return EexilyResponse(
      message: e.response?.data["message"] ?? "An error occurred.",
      payload: null,
      status: false,
    );
  } catch (e) {
    log("Create Scheduled Order: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse<UserOrder?>> createExpressOrder(
  Map<String, dynamic> map,
) async {
  try {
    Response response = await dio.post(
      "/express-refill",
      data: map,
      options: configuration,
    );

    if (response.statusCode! < 300) {
      Map<String, dynamic> data = response.data["payload"];
      Map<String, dynamic> transaction = data["transactionData"];
      List<dynamic> states = data["statusHistory"];
      List<OrderStates> orderStates = [];
      for (var element in states) {
        OrderStates state = OrderStates(
          state: convertState(element["status"]),
          timestamp: element["updatedAt"],
        );
        orderStates.add(state);
      }

      UserOrder userOrder = UserOrder(
        address: data["address"],
        location: data["location"] ?? "",
        id: data["_id"],
        quantity: (data["quantity"] as num).toInt(),
        states: orderStates,
        scheduledTime: data["timeScheduled"],
        pickedUpTime: data["pickupDate"],
        paymentMethod: data["paymentMethod"],
        status: data["status"],
        code: data["gcode"],
        price: ((data["price"] + data["deliveryFee"]) as num).toDouble(),
        paymentUrl: transaction["paymentUrl"],
        reference: transaction["reference"],
      );

      return EexilyResponse(
        message: "Success",
        payload: userOrder,
        status: true,
      );
    }
  } on DioException catch (e) {
    return EexilyResponse(
      message: e.response?.data["message"] ?? "An error occurred.",
      payload: null,
      status: false,
    );
  } catch (e) {
    log("Create Express Order: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse<List<Order>>> getDriverScheduledIncomingOrders(
    String driverId) async {
  try {
    Response response = await dio.get(
      "/refill-schedule/rider/$driverId",
      options: configuration,
    );

    if (response.statusCode! == 200) {
      return const EexilyResponse(
        message: "Orders Retrieved",
        payload: [],
        status: true,
      );
    }
  } on DioException catch (e) {
    return EexilyResponse(
      message: e.response?.data["message"] ?? "An error occurred.",
      payload: [],
      status: false,
    );
  } catch (e) {
    log("Get Driver Scheduled Orders: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: [],
    status: false,
  );
}

Future<EexilyResponse<List<Order>>> getRiderExpressIncomingOrders(
    String riderId) async {
  try {
    Response response = await dio.get(
      "/express-refill/rider/$riderId",
      options: configuration,
    );

    if (response.statusCode! == 200) {
      List<Order> orders = [];
      List<dynamic> _orders = response.data["payload"] as List<dynamic>;

      for(var element in _orders) {
        Order order = Order(
          deliveryDate: DateTime.parse(element["timeScheduled"]),
          address: element["address"],
          name: element["user"]?["firstName"] ?? "Test Name",
          phone: element["phone"] ?? "08012345678",
          price: (element["price"] as num).toDouble(),
          status: element["status"] != "DELIVERED" ? OrderStatus.pending : OrderStatus.completed,
          code: element["gcode"],
          id: element["_id"],
          gasQuantity: (element["quantity"] as num).toInt(),
          riderName: element["rider"]["name"] ?? "Test Rider Name",
         );
        orders.add(order);
      }

      Map map = {
        "payload": [
          {
            "_id": "67443e17f8222777673e0296",
            "sellerType": "MERCHANT",
            "pickupDate": "2024-11-25T10:06:30.061Z",
            "quantity": 1,
            "address": "bsbsnsnsn",
            "price": 1100,
            "deliveryFee": 80,
            "paymentMethod": "Paystack",
            "user": "674378f53f42156f485e0238",
            "status": "PAID",
            "merchant": "674242af1b7b02690ced52da",
            "timeScheduled": "2024-11-25T09:01:49.867Z",
            "statusHistory": [
              {
                "status": "PENDING",
                "updatedAt": "2024-11-25T09:06:31.387Z",
                "_id": "67443e17f8222777673e0297"
              },
              {
                "status": "MATCHED",
                "updatedAt": "2024-11-25T09:06:32.738Z",
                "_id": "67443e18f8222777673e02a0"
              },
              {
                "status": "PAID",
                "updatedAt": "2024-11-25T09:06:49.013Z",
                "_id": "67443e29f8222777673e02a4"
              }
            ],
            "createdAt": "2024-11-25T09:06:31.387Z",
            "updatedAt": "2024-11-25T09:06:49.013Z",
            "gcode": "G41CE",
            "__v": 0,
            "rider": "674435f837bc354ef857f31c",
            "transactionData": {
              "paymentUrl": "https://checkout.paystack.com/74rw7gl9mb91sxl",
              "reference": "ref_1732525592076",
            },
          },
        ],
      };


      return EexilyResponse(
        message: "Orders Retrieved",
        payload: orders,
        status: true,
      );
    }
  } on DioException catch (e) {
    return EexilyResponse(
      message: e.response?.data["message"] ?? "An error occurred.",
      payload: [],
      status: false,
    );
  } catch (e) {
    log("Get Rider Express Orders: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: [],
    status: false,
  );
}

Future<EexilyResponse<List<Order>>> getMerchantExpressOrders(String id) async {
  try {
    Response response = await dio.get(
      "/express-refill/merchant/$id",
      options: configuration,
    );

    if (response.statusCode! == 200) {
      List<dynamic> data = response.data["payload"];
      List<Order> orders = [];

      return EexilyResponse(
        message: "Retrieved Merchant Orders",
        payload: orders,
        status: true,
      );
    }
  } on DioException catch (e) {
    return EexilyResponse(
      message: e.response?.data["message"] ?? "An error occurred.",
      payload: [],
      status: false,
    );
  } catch (e) {
    log("Retrieve Merchant Orders: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: [],
    status: false,
  );
}
