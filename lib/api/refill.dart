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
        price: ((data["price"] + data["deliveryFee"])
                as num)
            .toDouble(),
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
