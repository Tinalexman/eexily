import "package:eexily/components/notification.dart";

import "base.dart";

Future<EexilyResponse<List<Notification>?>> notifications() async {
  try {
    Response response = await dio.get(
      "/notifications",
      options: configuration,
    );
    if (response.statusCode! == 200) {
      List<dynamic> data = response.data["payload"];
      List<Notification> notifications = [];

      for (var element in data) {
        Notification notification = Notification(
          timestamp: DateTime.parse(element["createdAt"]),
          message: element["message"],
          read: element["read"],
          actionLabel: element["actionLabel"] ?? "New Notification",
          notificationType: element["notificationType"] ?? "",
        );
        notifications.add(notification);
      }

      return EexilyResponse(
        message: "Success",
        payload: notifications,
        status: true,
      );
    }
  } catch (e) {
    log("Notifications Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}
