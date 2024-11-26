import "package:eexily/components/gas_data.dart";
import "package:eexily/components/user/user.dart";
import "package:eexily/components/user/user_factory.dart";

import "base.dart";

Future<EexilyResponse<String?>> register(Map<String, dynamic> data) async {
  try {
    Response response = await dio.post("/auth/sign-up", data: data);
    if (response.statusCode! == 200) {
      String token = response.data["payload"]["token"];
      accessToken = token;

      String userId = response.data["payload"]["user"]["_id"];

      return EexilyResponse(
        message: "Account created successfully",
        payload: userId,
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

Future<EexilyResponse<List<dynamic>?>> login(Map<String, dynamic> data) async {
  try {
    Response response = await dio.post("/auth/sign-in", data: data);
    if (response.statusCode! == 200) {
      Map<String, dynamic> data = response.data["payload"]["user"];
      Map<String, dynamic>? typeData = response.data["payload"]["typeObject"];
      String token = response.data["payload"]["token"];
      accessToken = token;
      bool hasCompleted = response.data["payload"]["isGas"];
      data["isGas"] = hasCompleted;

      UserBase base = UserFactory.createUser(data, typeData: typeData);
      Map<String, dynamic>? gasData =
          response.data["payload"]["gasPredictionData"];

      GasData gd = GasData(
        gasSize: typeData != null ? typeData["gasSize"] ?? 0 : 0,
      );

      if (gasData != null) {
        gd.completionDate = gasData["completionDate"];
        gd.gasAmountLeft =
            (gasData["estimatedGasRemaining"] as num).toDouble() ?? 0.0;
        gd.isPaused = gasData["isPause"];
      }

      return EexilyResponse(
        message: "Welcome back to GasFeel",
        payload: [base, gd],
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
    Response response =
        await dio.post("/auth/verify-user", data: {"email": email});
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

Future<EexilyResponse> forgot(Map<String, String> details) async {
  try {
    Response response = await dio.patch(
      "/auth/forgotten-password",
      data: details,
    );
    if (response.statusCode! < 300) {
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
    log("Forgot Password Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}

Future<EexilyResponse> reset(Map<String, String> details) async {
  try {
    Response response = await dio.post(
      "/auth/update-password",
      data: details,
    );
    if (response.statusCode! < 300) {
      return const EexilyResponse(
        message: "Password reset successfully. Proceed to login.",
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
    log("Reset Password Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}
