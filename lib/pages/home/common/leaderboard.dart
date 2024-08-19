import 'package:eexily/components/points.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    List<int> saverPoints = ref.watch(saverPointsProvider);
    List<PointsSaved> leaderboard = ref.watch(leaderPointsProvider);

    return Scaffold(
      body: Container(
        width: 375.w,
        height: 812.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primary,
              Color(0xFFDEECFF),
              Colors.white,
            ],
            stops: [
              0.28,
              0.55,
              1.0,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 70.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => context.router.pop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 26.r,
                  ),
                ),
                SizedBox(width: 15.w),
                Text(
                  "Leaderboard",
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    ref.watch(pointTypeProvider.notifier).state = PointType.gas;
                    context.router.pushNamed(
                      Pages.pointsSaver,
                      extra: PointType.gas,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/Gold Saver.png",
                        width: 36.w,
                        height: 32.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 2.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gas saver point",
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${saverPoints[0]}",
                                style: context.textTheme.bodySmall!.copyWith(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white,
                                size: 12.r,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.watch(pointTypeProvider.notifier).state =
                        PointType.belly;
                    context.router.pushNamed(
                      Pages.pointsSaver,
                      extra: PointType.belly,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/Belly Saver.png",
                        width: 36.w,
                        height: 32.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 2.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Belly saver point",
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${saverPoints[1]}",
                                style: context.textTheme.bodySmall!.copyWith(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white,
                                size: 12.r,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.h),
            Row(
              children: [
                SizedBox(
                  width: 120.w,
                  child: Center(
                    child: Text(
                      "Name",
                      style: context.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100.w,
                  child: Center(
                    child: Text(
                      "Gas saver pt",
                      style: context.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100.w,
                  child: Center(
                    child: Text(
                      "Belly saver pt",
                      style: context.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Container(
                width: 375.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.5.r),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    if (index == leaderboard.length) {
                      return SizedBox(height: 40.h);
                    }

                    PointsSaved point = leaderboard[index];

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5.r),
                        color: primary.withOpacity(0.05),
                      ),
                      child: SizedBox(
                        height: 40.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120.w,
                              child: Row(
                                children: [
                                  SizedBox(width: 5.w),
                                  Image.asset(
                                    point.image,
                                    width: 30.r,
                                    height: 30.r,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    point.name,
                                    style:
                                        context.textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 90.w,
                              child: Center(
                                child: Text(
                                  "${point.gas}",
                                  style: context.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 90.w,
                              child: Center(
                                child: Text(
                                  "${point.belly}",
                                  style: context.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: primary,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemCount: leaderboard.length + 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
