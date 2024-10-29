import "package:eexily/components/user/user.dart";
import "package:eexily/components/user/user_factory.dart";

import "base.dart";

Future<EexilyResponse> updateRiderUser(Map<String, dynamic> data, String userId) async {
  try {
    Response response = await dio.patch(
      "/rider/update/$userId",
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
