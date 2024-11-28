import 'package:eexily/components/cheffy_message.dart';
import 'base.dart';

const String openAIKey = "";


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
          "Authorization": "Bearer $openAIKey",
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
