import 'package:eexily/tools/constants.dart';
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
    bool darkTheme = context.isDark;

    return Container(
      width: 375.w,
      height: 90.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.5.r),
        color: primary,
        boxShadow: [
          BoxShadow(
            color: darkTheme ? Colors.white12 : Colors.black12,
            blurRadius: 50,
          )
        ]
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 10.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Track Gas Usage",
            style: context.textTheme.bodySmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/Gas Station.png"),
              SizedBox(height: 10.h),
              Text(
                "Refill Gas",
                style: context.textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            "Refill Gas",
            style: context.textTheme.bodySmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
