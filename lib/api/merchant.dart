import "base.dart";

Future<EexilyResponse> updateMerchantUser(
    Map<String, dynamic> data, String userId) async {
  try {
    Response response = await dio.patch(
      "/merchant/$userId",
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
    log("Create Merchant: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse<List<dynamic>?>> getOrders() async {
  try {
    Response response = await dio.get(
      "/refill-schedule",
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
