import "package:eexily/tools/constants.dart";
import "base.dart";


Future<EexilyResponse> authenticate(String path, Map<String, dynamic> data) async {
  try {
    Response response = await dio.post("/auth/${path.path}", data: data);
    if(response.statusCode! == 201) {
      log("${response.data}");
    }
  } catch (e) {
    log("Authentication Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}


Future<EexilyResponse> verify(Map<String, dynamic> data) async {
  try {
    Response response = await dio.post("/verify-user", data: data);
    if(response.statusCode! == 201) {

    }
  } catch (e) {
    log("Verification Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}
