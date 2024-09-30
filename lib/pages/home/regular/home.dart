import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userProvider) as User;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Hello,",
              style: context.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "${user.firstName} ${user.lastName}!",
              style: context.textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            const UserGasStatistics(),
            SizedBox(height: 20.h),
            const Center(child: GasContainer()),
            SizedBox(height: 20.h),
            Tooltip(
              message:
                  "You're using the first version of our gas tracking feature. It might not always be perfect for now, but don’t worry—it gets better the more you use it. Over time, you'll see more accurate tracking and reminders. Thanks for being one of our early users and helping us make things better!",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primary,
                    size: 14.r,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "Beta version",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
