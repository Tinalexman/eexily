import "base.dart";

Future<EexilyResponse> notifications() async {
  try {
    Response response = await dio.get("/notifications");
    if (response.statusCode! == 201) {}
  } catch (e) {
    log("Notifications Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}
