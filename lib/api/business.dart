import "package:eexily/components/user/user.dart";
import "package:eexily/components/user/user_factory.dart";

import "base.dart";

Future<EexilyResponse> createBusinessUser(Map<String, dynamic> data) async {
  try {
    Response response = await dio.post(
      "/business",
      data: data,
      options: configuration,
    );
    if (response.statusCode! == 200) {
      Map<String, dynamic> data = response.data["payload"]["user"];
      UserBase base = UserFactory.createUser(data);
      return EexilyResponse(
        message: "Account Created",
        payload: base,
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
    log("Create Business: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}
