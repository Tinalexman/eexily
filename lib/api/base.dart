import 'package:dio/dio.dart';

export 'dart:developer' show log;

export 'package:dio/dio.dart';

// const String baseURL = "https://eexily-backend.onrender.com";
const String baseURL = "http://192.168.87.168:3030";

const String nubanUrl = "https://app.nuban.com/api/NUBAN-BUEOFPVS2352/";
//https://app.nuban.com.ng/api/NUBAN-BUEOFPVS2352?bank_code=058&acc_no=0435172012
//https://app.nuban.com.ng/bank_codes.json is a list of responses like {
//        "bank_name": "Covenant Microfinance Bank",
//        "code": "070006"
//    },

String accessToken = "";

const String imgPrefix = "data:image/jpeg;base64,";
const String vidPrefix = "data:image/mp4;base64,";

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseURL,
    receiveTimeout: const Duration(seconds: 120),
    connectTimeout: const Duration(seconds: 120),
    sendTimeout: const Duration(seconds: 120),
  ),
);

void initializeAPIServices() {
  dio.interceptors.add(
    LogInterceptor(
      responseBody: true,
      requestBody: true,
    ),
  );
}

Options get configuration => Options(
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $accessToken"
      },
    );

class EexilyResponse<T> {
  final String message;
  final T payload;
  final bool status;

  const EexilyResponse({
    required this.message,
    required this.payload,
    required this.status,
  });
}
