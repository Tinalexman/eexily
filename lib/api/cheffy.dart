import 'package:eexily/components/cheffy_message.dart';
import 'base.dart';

const String word =
    "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";


Future<EexilyResponse> sendMessageToCheffy(List<CheffyMessage> messages) async {
  List<Map<String, dynamic>> jsonedMessages = [];
  for (CheffyMessage message in messages) {
    jsonedMessages.add(message.toJson());
  }

  Dio cheffyDio = Dio();

  try {
    Response response = await cheffyDio.post(
      "https://api.openai.com/v1/chat/completions",
      data: {
        "model": "gpt-3.5-turbo",
        "messages": jsonedMessages,
      },
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Authorization": "Bearer $word",
        },
      ),
    );
    if (response.statusCode! == 200) {
      Map<String, dynamic> map = response.data as Map<String, dynamic>;
      log("$map");
    }
  } catch (e) {
    log("Send Cheffy Message Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred",
    payload: null,
    status: false,
  );
}
