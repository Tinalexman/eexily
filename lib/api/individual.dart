import "package:eexily/components/gas_data.dart";
import "package:eexily/components/order.dart";
import "package:eexily/components/user/user.dart";
import "package:eexily/components/user/user_factory.dart";

import "base.dart";

Future<EexilyResponse> updateIndividualUser(
    Map<String, dynamic> data, String userId) async {
  try {
    Response response = await dio.patch(
      "/individual/$userId",
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
    Map<String, dynamic> data, String userId) async {
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

Future<EexilyResponse<List<UserOrder>>> getUserStandardOrders() async {
  try {
    Response response = await dio.get(
      "/refill-schedule",
      options: configuration,
    );

    if (response.statusCode! == 200) {
      List<dynamic> data = response.data["payload"];
      List<UserOrder> orders = [];

      for (var element in data) {
        UserOrder userOrder = UserOrder(
          id: element["_id"],
          states: [
            // element["status"]
          ],
          price: (element["price"] as num).toDouble() +
              (element["deliveryFee"] as num).toDouble(),
          quantity: (element["quantity"] as num).toInt(),
          code: element["gcode"],
          paymentMethod: element["paymentMethod"],
          pickedUpTime: element["pickedUpTime"],
          scheduledTime: element["timeScheduled"],
          address: element["address"],
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

Future<EexilyResponse<List<UserOrder>>> getUserExpressOrders() async {
  try {
    Response response = await dio.get(
      "/express-refill/user",
      options: configuration,
    );

    if (response.statusCode! == 200) {
      List<dynamic> data = response.data["payload"];
      List<UserOrder> orders = [];

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

        UserOrder userOrder = UserOrder(
          id: element["_id"],
          states: orderStates,
          price: (element["price"] as num).toDouble() +
              (element["deliveryFee"] as num).toDouble(),
          quantity: (element["quantity"] as num).toInt(),
          code: element["gcode"],
          status: element["status"],
          paymentMethod: element["paymentMethod"],
          pickedUpTime: element["pickupDate"],
          scheduledTime: element["timeScheduled"],
          address: element["address"],
          sellerType: element["sellerType"],
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

Future<EexilyResponse<UserOrder?>> getUserOrderByGCode(String code) async {
  try {
    Response response = await dio.get(
      "/refill-schedule/by-gcode/$code",
      options: configuration,
    );

    if (response.statusCode! == 200) {
      Map<String, dynamic> data = response.data["payload"];

      UserOrder userOrder = UserOrder(
        id: data["_id"],
        states: [
          // orderState: data["status"]
        ],
        price: (data["price"] as num).toDouble() +
            (data["deliveryFee"] as num).toDouble(),
        quantity: (data["quantity"] as num).toInt(),
      );

      return EexilyResponse(
        message: "Gas Orders Retrieved",
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
    log("Get Order Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}
