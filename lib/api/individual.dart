import "package:eexily/components/gas_data.dart";
import "package:eexily/components/order.dart";

import "base.dart";

Future<EexilyResponse> updateIndividualUser(
    Map<String, dynamic> data, String userId) async {
  try {
    Response response = await dio.patch(
      "/individual",
      data: data,
      options: configuration,
    );

    if (response.statusCode! == 200) {
      return const EexilyResponse(
        message: "Account Updated",
        payload: null,
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
    log("Create Individual: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse<GasData?>> createIndividualGasQuestions(
    Map<String, dynamic> data) async {
  try {
    Response response = await dio.post(
      "/prediction",
      data: data,
      options: configuration,
    );

    if (response.statusCode! == 201) {
      Map<String, dynamic> map = response.data["payload"];

      GasData gd = GasData(
        gasSize: -1,
        gasAmountLeft: (map["estimatedGasRemaining"] as num).toDouble() ?? 0.0,
        completionDate: map["completionDate"],
      );

      return EexilyResponse(
        message: "Gas Details Completed",
        payload: gd,
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
    log("Create Individual Gas Questions: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse<GasData?>> updateGasData(
    Map<String, dynamic> data) async {
  try {
    Response response = await dio.patch(
      "/prediction/refill",
      data: data,
      options: configuration,
    );

    if (response.statusCode! == 200) {
      Map<String, dynamic> map = response.data["payload"];

      GasData gd = GasData(
        gasSize: -1,
        gasAmountLeft: (map["estimatedGasRemaining"] as num).toDouble() ?? 0.0,
        completionDate: map["completionDate"],
      );

      return EexilyResponse(
        message: "Gas Details Updated",
        payload: gd,
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
    log("Update Gas Data: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse> toggleGasTracker() async {
  try {
    Response response = await dio.patch(
      "/prediction/toggle",
      options: configuration,
    );

    if (response.statusCode! < 300) {
      return const EexilyResponse(
        message: "Gas Tracker Toggled",
        payload: null,
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
    log("Toggle Gas Tracker: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse<List<Order>>> getUserStandardOrders() async {
  try {
    Response response = await dio.get(
      "/refill-schedule",
      options: configuration,
    );

    if (response.statusCode! == 200) {
      List<dynamic> data = response.data["payload"];
      List<Order> orders = [];

      for (var element in data) {
        Order userOrder = Order(
          id: element["_id"],
          states: [
            // element["status"]
          ],
          price: (element["price"] as num).toDouble() +
              (element["deliveryFee"] as num).toDouble(),
          quantity: (element["quantity"] as num).toInt(),
          code: element["gcode"],
          paymentMethod: element["paymentMethod"],
        );
        orders.add(userOrder);
      }

      return EexilyResponse(
        message: "Gas Orders Retrieved",
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
    log("Create Scheduled Order: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: [],
    status: false,
  );
}

Future<EexilyResponse<List<Order>>> getUserExpressOrders() async {
  try {
    Response response = await dio.get(
      "/express-refill/user",
      options: configuration,
    );

    if (response.statusCode! == 200) {
      List<dynamic> data = response.data["payload"];
      List<Order> orders = [];

      for (var element in data) {
        List<dynamic> states = element["statusHistory"];
        List<OrderStates> orderStates = [];
        for (var element in states) {
          OrderStates state = OrderStates(
            state: convertState(element["status"]),
            timestamp: element["updatedAt"],
          );
          orderStates.add(state);
        }

        Map<String, dynamic> metadata = element["metaData"];

        Order userOrder = Order(
          id: element["_id"],
          states: orderStates,
          price: (element["price"] as num).toDouble() +
              (element["deliveryFee"] as num).toDouble(),
          quantity: (element["quantity"] as num).toInt(),
          code: element["gcode"],
          status: element["status"],
          paymentMethod: element["paymentMethod"],
          createdAt: element["createdAt"],
          metadata: OrderMetadata(
            riderName: metadata["riderName"] ?? "",
            gasStationAddress: metadata["gasStationAddress"] ?? "",
            gasStationLocation: metadata["gasStationLocation"] ?? "",
            gasStationName: metadata["gasStationName"] ?? "",
            merchantAddress: metadata["merchantAddress"] ?? "",
            merchantName: metadata["merchantName"] ?? "",
            merchantPhoneNumber: metadata["merchantPhoneNumber"] ?? "",
            pickUpAddress: metadata["pickUpAddress"] ?? "",
            pickUpLocation: metadata["pickUpLocation"] ?? "",
            riderPhoneNumber: metadata["riderPhoneNumber"] ?? "",
            userName: metadata["userName"] ?? "",
            userPhoneNumber: metadata["userPhoneNumber"] ?? "",
          ),
          sellerType: element["sellerType"],
          paymentUrl: element["transactionData"]["paymentUrl"],
          reference: element["transactionData"]["reference"],
        );
        orders.add(userOrder);
      }

      return EexilyResponse(
        message: "Gas Orders Retrieved",
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
    log("Create Scheduled Order: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: [],
    status: false,
  );
}
