import "package:eexily/components/user/user.dart";
import "package:eexily/components/user/user_factory.dart";

import "base.dart";

Future<EexilyResponse> register(Map<String, dynamic> data) async {
  try {
    Response response = await dio.post("/auth/sign-up", data: data);
    if (response.statusCode! == 200) {
      String token = response.data["payload"]["token"];
      accessToken = token;

      return const EexilyResponse(
        message: "Account created successfully",
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
    log("Sign Up Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse<UserBase?>> login(Map<String, dynamic> data) async {
  try {
    Response response = await dio.post("/auth/sign-in", data: data);
    if (response.statusCode! == 200) {
      Map<String, dynamic> data = response.data["payload"]["user"];
      String token = response.data["payload"]["token"];
      accessToken = token;

      UserBase base = UserFactory.createUser(data);

      return EexilyResponse(
        message: "Welcome back to GasFeel",
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
    log("Sign In Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse<UserBase?>> verify(Map<String, dynamic> data) async {
  try {
    Response response = await dio.post("/auth/verify-user", data: data);
    if (response.statusCode! == 200) {
      Map<String, dynamic> data = response.data["payload"]["user"];
      String token = response.data["payload"]["token"];
      accessToken = token;

      UserBase base = UserFactory.createUser(data);
      return EexilyResponse(
        message: "Account Verified",
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
    log("Verification Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse> resendToken(String email) async {
  try {
    Response response = await dio.post("/auth/verify-user", data: {"email": email});
    if (response.statusCode! == 200) {

      return const EexilyResponse(
        message: "Verification Code Sent",
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
    log("Resend Token Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}