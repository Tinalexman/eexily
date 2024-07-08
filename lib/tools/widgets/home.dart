import 'dart:async';
import 'dart:developer';

import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GasTrackerContainer extends ConsumerStatefulWidget {
  const GasTrackerContainer({super.key});

  @override
  ConsumerState<GasTrackerContainer> createState() =>
      _GasTrackerContainerState();
}

class _GasTrackerContainerState extends ConsumerState<GasTrackerContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.router.pushNamed(Pages.usage),
          child: Container(
            width: 130.w,
            height: 130.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              image: const DecorationImage(
                image: AssetImage("assets/images/day mask.png"),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "My Usage",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Image.asset("assets/images/chart.png")
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 7.5.r,
                      height: 7.5.r,
                      decoration: const BoxDecoration(
                        color: secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 7.5.w),
                    Text(
                      "Daily Usage",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 7.5.r,
                      height: 7.5.r,
                      decoration: const BoxDecoration(
                        color: secondary3,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 7.5.w),
                    Text(
                      "Weekly Usage",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 7.5.r,
                      height: 7.5.r,
                      decoration: const BoxDecoration(
                        color: secondary2,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 7.5.w),
                    Text(
                      "Monthly Usage",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 200.w,
          height: 130.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: secondary3,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 10.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/gas station.png",
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "Refill Gas",
                    style: context.textTheme.titleSmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/award.png",
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "Earn Rewards",
                    style: context.textTheme.titleSmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GasTimer extends ConsumerStatefulWidget {
  const GasTimer({super.key});

  @override
  ConsumerState<GasTimer> createState() => _GasTimerState();
}

class _GasTimerState extends ConsumerState<GasTimer> {
  Timer? timer;
  int count = 0;
  String duration = "00:00:00";

  void listen() {
    ref.listen(startGasTimerProvider, (oldVal, newVal) {
      if (!oldVal! && newVal) {
        setState(() {
          count = 0;
          duration = "00:00:00";
        });

        timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            if(!mounted) return;
            setState(() {
              duration = formatDuration(count + 1);
              count++;
            });
          },
        );
      } else if (oldVal && !newVal) {
        timer?.cancel();
        setState(() {
          timer = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listen();

    return Container(
      width: 180.w,
      height: 75.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.5.r),
        border: Border.all(color: primary),
        color: primary50.withOpacity(0.1),
      ),
      alignment: Alignment.center,
      child: Text(
        duration,
        style: context.textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.w500,
          color: primary,
        ),
      ),
    );
  }
}
