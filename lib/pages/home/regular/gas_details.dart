import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:eexily/tools/widgets/gas_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class GasDetailsPage extends ConsumerStatefulWidget {
  const GasDetailsPage({super.key});

  @override
  ConsumerState<GasDetailsPage> createState() => _GasDetailsPageState();
}

class _GasDetailsPageState extends ConsumerState<GasDetailsPage> {
  @override
  Widget build(BuildContext context) {
    bool isGasActive = ref.watch(playGasAnimationProvider);
    int cylinderSize = ref.watch(gasCylinderSizeProvider);
    int level = ref.watch(gasLevelProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Gas Details",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.router.pushNamed(Pages.lastRefill),
            icon: const Icon(
              IconsaxPlusBroken.edit_2,
              color: monokai,
            ),
            iconSize: 26.r,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: SizedBox(
                      width: 375.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Gas Statistics",
                            style: context.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: (level * 0.01 * cylinderSize)
                                          .toStringAsFixed(1),
                                      style: context.textTheme.displaySmall!
                                          .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "/${cylinderSize}kg",
                                      style: context.textTheme.titleLarge!
                                          .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Gas level",
                                    style:
                                        context.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "$level%",
                                    style:
                                        context.textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 5.h),
                          SizedBox(
                            width: 375.w,
                            child: LinearProgressIndicator(
                              value: level * 0.01,
                              color: gasColor(level * 0.01),
                              backgroundColor: primary50.withOpacity(0.25),
                              minHeight: 25.h,
                              borderRadius: BorderRadius.circular(7.5.h),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    isGasActive ? secondary : Colors.white70,
                                radius: 5.r,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                isGasActive ? "Active" : "Inactive",
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color:
                                      isGasActive ? secondary : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                const Center(child: GasContainer()),
                SizedBox(height: 20.h),
                Text(
                  "Won't be around for a while?",
                  style: context.textTheme.titleLarge!.copyWith(
                    color: monokai,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "You can enable or disable your gas tracker here.",
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: monokai,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        elevation: 1.0,
        onPressed: () =>
            ref.watch(playGasAnimationProvider.notifier).state = !isGasActive,
        child: AnimatedSwitcherTranslation.right(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isGasActive ? IconsaxPlusBroken.pause : IconsaxPlusBroken.play,
            key: ValueKey<bool>(isGasActive),
            color: Colors.white,
            size: 32.r,
          ),
        ),
      ),
    );
  }
}
