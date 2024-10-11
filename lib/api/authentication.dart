import "package:eexily/components/user/user.dart";
import "package:eexily/components/user/user_factory.dart";

import "base.dart";

Future<EexilyResponse<UserBase?>> register(Map<String, dynamic> data) async {
  try {
    Response response = await dio.post("/auth/sign-up", data: data);
    if (response.statusCode! == 200) {
      Map<String, dynamic> map = response.data["payload"]["user"];
      UserBase userBase = UserBase(
        email: map["email"],
        role: convertToRole(map["type"]),
      );
      return EexilyResponse(
        message: "Account created successfully",
        payload: userBase,
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
      Map<String, dynamic> map = response.data["payload"]["user"];
      UserBase userBase = UserBase(
        email: map["email"],
        role: convertToRole(map["type"]),
      );
      return EexilyResponse(
        message: "Welcome back to GasFeel",
        payload: userBase,
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

// {"message":"Success","payload":{"user":{"_id":"6709ae06484353ce3eea9b6e","email":"taiwoluwatobilobafestus@gmail.com","password":"$2b$08$QpmrHWnN.PCJCCJ6fSQuI.lpEIB3lnwMEUbM3NB.ty2I2hLqDQxea","isVerified":true,"generatedOtp":null,"generatedOtpExpiration":null,"type":"INDIVIDUAL","createdAt":"2024-10-11T23:00:22.401Z","updatedAt":"2024-10-11T23:13:17.448Z","__v":0},"gas":null,"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MDlhZTA2NDg0MzUzY2UzZWVhOWI2ZSIsImlhdCI6MTcyODY4ODM5N30.JhWRLORmDlyknKuJ2br2sFSxUJwrLkP9wPIbEDMZus4"}}
