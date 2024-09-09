import 'package:eexily/components/notification.dart' as n;
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    List<n.Notification> notifications = ref.watch(notificationsProvider);

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
          child: ListView.separated(
            itemBuilder: (_, index) => NotificationContainer(
              notification: notifications[index],
            ),
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemCount: notifications.length,
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
          if (!notification.read)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "New Notification",
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 5.w),
                CircleAvatar(
                  radius: 4.r,
                  backgroundColor: secondary,
                ),
              ],
            ),
          if (!notification.read) SizedBox(height: 5.h),
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
