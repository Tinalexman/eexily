import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart';
export 'dart:developer' show log;

export 'package:dio/dio.dart';

const String onlineBase = "eexily-backend.onrender.com";
const String localBase = "192.168.28.93:7030";
const String baseURL = "https://$onlineBase";

String accessToken = "";

const String imgPrefix = "data:image/jpeg;base64,";
const String vidPrefix = "data:image/mp4;base64,";

const String notificationSignal = 'notification';

final Map<String, List<Function>> _socketManager = {
  notificationSignal: [],
};

Socket? _socket;



void initSocket(String id) {
  _socket = io('ws://$onlineBase',
      OptionBuilder().setTransports(['websocket']).build());

  _socket?.onConnect((e) {
    log("Connected To WebSocket");
    emit("init", id);
  });

  _socket?.onConnectError((e) => log("Socket Connection Error: $e"));
  _socket?.onDisconnect((e) => log('Disconnected From WebSocket'));
  _socket?.onError((e) => log("WebSocket Error: $e"));

  setupSignalHandlers(notificationSignal);
}

void setupSignalHandlers(String signal) {
  _socket?.on(signal, (data) {
    if (data == null) return;
    List<Function> handlers = _socketManager[signal]!;
    for (Function handler in handlers) {
      handler(data);
    }
  });
}

void addHandler(String key, Function handler) =>
    _socketManager[key]?.add(handler);

void removeHandler(String key, Function handler) =>
    _socketManager[key]?.remove(handler);

void emit(String signal, dynamic data) => _socket?.emit(signal, data);

void shutdown() => _socket?.disconnect();

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
