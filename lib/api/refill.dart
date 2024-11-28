import "package:eexily/components/order.dart";

import "base.dart";

Future<EexilyResponse<Order?>> createScheduledOrder(
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

Future<EexilyResponse<Order?>> createExpressOrder(
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

      Order userOrder = Order(
        id: data["_id"],
        quantity: (data["quantity"] as num).toInt(),
        states: orderStates,
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
      List<Order> orders = [];
      List<dynamic> _orders = response.data["payload"] as List<dynamic>;

      for (var element in _orders) {
        Map<String, dynamic> metadata = element["metaData"];
        List<dynamic> states = element["statusHistory"];
        List<OrderStates> orderStates = [];
        for (var element in states) {
          OrderStates state = OrderStates(
            state: convertState(element["status"]),
            timestamp: element["updatedAt"],
          );
          orderStates.add(state);
        }

        Order order = Order(
          createdAt: element["createdAt"],
          price: (element["price"] as num).toDouble(),
          status: element["status"],
          code: element["gcode"],
          id: element["_id"],
          quantity: (element["quantity"] as num).toInt(),
          metadata: OrderMetadata(
            riderName: metadata["riderName"] ?? "",
            gasStationAddress: metadata["gasStationAddress"] ?? "",
            gasStationLocation: metadata["gasStationLocation"] ?? "",
            gasStationName: metadata["gasStationName"] ?? "",
            merchantAddress: metadata["merchantAddress"] ?? "",
            merchantLocation: metadata["merchantLocation"] ?? "",
            merchantName: metadata["merchantName"] ?? "",
            merchantPhoneNumber: metadata["merchantPhoneNumber"] ?? "",
            pickUpAddress: metadata["pickUpAddress"] ?? "",
            pickUpLocation: metadata["pickUpLocation"] ?? "",
            riderPhoneNumber: metadata["riderPhoneNumber"] ?? "",
            userName: metadata["userName"] ?? "",
            userPhoneNumber: metadata["userPhoneNumber"] ?? "",
          ),
        );
        orders.add(order);
      }

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

      for (var element in _orders) {
        Map<String, dynamic> metadata = element["metaData"];
        List<dynamic> states = element["statusHistory"];
        List<OrderStates> orderStates = [];
        for (var element in states) {
          OrderStates state = OrderStates(
            state: convertState(element["status"]),
            timestamp: element["updatedAt"],
          );
          orderStates.add(state);
        }

        Order order = Order(
          price: (element["price"] as num).toDouble(),
          status: element["status"],
          code: element["gcode"],
          id: element["_id"],
          quantity: (element["quantity"] as num).toInt(),
          createdAt: element["createdAt"],
          sellerType: element["sellerType"] ?? "",
          states: orderStates,
          metadata: OrderMetadata(
            riderName: metadata["riderName"] ?? "",
            gasStationAddress: metadata["gasStationAddress"] ?? "",
            gasStationLocation: metadata["gasStationLocation"] ?? "",
            gasStationName: metadata["gasStationName"] ?? "",
            merchantAddress: metadata["merchantAddress"] ?? "",
            merchantLocation: metadata["merchantLocation"] ?? "",
            merchantName: metadata["merchantName"] ?? "",
            merchantPhoneNumber: metadata["merchantPhoneNumber"] ?? "",
            pickUpAddress: metadata["pickUpAddress"] ?? "",
            pickUpLocation: metadata["pickUpLocation"] ?? "",
            riderPhoneNumber: metadata["riderPhoneNumber"] ?? "",
            userName: metadata["userName"] ?? "",
            userPhoneNumber: metadata["userPhoneNumber"] ?? "",
          ),
        );
        orders.add(order);
      }

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
      List<Order> orders = [];
      List<dynamic> _orders = response.data["payload"] as List<dynamic>;

      for (var element in _orders) {
        Map<String, dynamic> metadata = element["metaData"];
        List<dynamic> states = element["statusHistory"];
        List<OrderStates> orderStates = [];
        for (var element in states) {
          OrderStates state = OrderStates(
            state: convertState(element["status"]),
            timestamp: element["updatedAt"],
          );
          orderStates.add(state);
        }
        Order order = Order(
          createdAt: element["createdAt"],
          price: (element["price"] as num).toDouble(),
          status: element["status"],
          code: element["gcode"],
          id: element["_id"],
          states: orderStates,
          quantity: (element["quantity"] as num).toInt(),
          metadata: OrderMetadata(
            riderName: metadata["riderName"] ?? "",
            gasStationAddress: metadata["gasStationAddress"] ?? "",
            gasStationLocation: metadata["gasStationLocation"] ?? "",
            gasStationName: metadata["gasStationName"] ?? "",
            merchantAddress: metadata["merchantAddress"] ?? "",
            merchantLocation: metadata["merchantLocation"] ?? "",
            merchantName: metadata["merchantName"] ?? "",
            merchantPhoneNumber: metadata["merchantPhoneNumber"] ?? "",
            pickUpAddress: metadata["pickUpAddress"] ?? "",
            pickUpLocation: metadata["pickUpLocation"] ?? "",
            riderPhoneNumber: metadata["riderPhoneNumber"] ?? "",
            userName: metadata["userName"] ?? "",
            userPhoneNumber: metadata["userPhoneNumber"] ?? "",
          ),
        );
        orders.add(order);
      }

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
    log("Retrieve Merchant Orders: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: [],
    status: false,
  );
}
