import 'package:eexily/components/notification.dart' as n;
import 'package:eexily/tools/constants.dart';
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
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.router.pop(),
          icon: const Icon(Icons.arrow_back),
          iconSize: 26.r,
        ),
        title: Text(
          "Notifications",
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView.separated(
            itemBuilder: (_, index) {
              if (index == notifications.length) {
                return SizedBox(height: 40.h);
              }

              n.Notification notification = notifications[index];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/Blue Logo.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (!notification.read)
                          Positioned(
                            top: 10.h,
                            right: 10.w,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 4.r,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    width: 270.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5.r),
                      color: primary.withOpacity(0.05),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    child: Column(
                      children: [
                        Text(
                          notification.message,
                          style: context.textTheme.bodyLarge,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => context.router.pushNamed(Pages.scheduleRefill),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                minimumSize: Size(100.w, 30.h),
                                fixedSize: Size(100.w, 30.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.5.r),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10.w)
                              ),
                              child: Text(
                                "Schedule a refill",
                                style: context.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            ElevatedButton(
                              onPressed: () => context.router.pushNamed(Pages.refillNow),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  minimumSize: Size(100.w, 30.h),
                                  fixedSize: Size(100.w, 30.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.5.r),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10.w)
                              ),
                              child: Text(
                                "Refill now",
                                style: context.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 20.h),
            itemCount: notifications.length + 1,
          ),
        ),
      ),
    );
  }
}
