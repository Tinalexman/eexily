import 'package:eexily/api/notification.dart';
import 'package:eexily/components/notification.dart' as n;
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getNotifications);
  }

  Future<void> getNotifications() async {
    if (loading) return;
    setState(() => loading = true);

    var response = await notifications();
    setState(() => loading = false);
    if (!response.status) {
      showMessage(response.message);
      return;
    }

    ref.watch(notificationsProvider.notifier).state = response.payload!;
  }

  void showMessage(String message) => showToast(message, context);

  @override
  Widget build(BuildContext context) {
    List<n.Notification> notifications =
        loading ? dummyNotifications : ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Notifications",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 5.h,
          ),
          child: (!loading && notifications.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/error.png",
                        width: 200.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        "No notifications available",
                        style: context.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: getNotifications,
                        child: Text(
                          "Click here to refresh",
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Skeletonizer(
                  enabled: loading,
                  child: ListView.separated(
                    itemBuilder: (_, index) => NotificationContainer(
                      notification: notifications[index],
                    ),
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemCount: notifications.length,
                  ),
                ),
        ),
      ),
    );
  }
}

class NotificationContainer extends StatelessWidget {
  final n.Notification notification;

  const NotificationContainer({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.message,
            style: context.textTheme.bodyLarge!.copyWith(
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            formatDateRawWithTime(notification.timestamp),
            style: context.textTheme.bodySmall!.copyWith(
              color: monokai,
            ),
          ),
        ],
      ),
    );
  }
}
