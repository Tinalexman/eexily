import 'dart:math';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/sale_report.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class RevenueChart extends ConsumerStatefulWidget {
  const RevenueChart({super.key});

  @override
  ConsumerState<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends ConsumerState<RevenueChart> {
  final List<String> filterOptions = [
    "This week",
    "Last week",
    "This month",
    "Last month",
    "Last 3 months",
  ];

  int currentFilterIndex = 0;
  double change = 12.5;

  late List<List<BarChartGroupData>> barData;

  @override
  void initState() {
    super.initState();
    barData = getData();
  }

  List<List<BarChartGroupData>> getData() {
    Random random = Random();
    return List.generate(
      filterOptions.length,
      (i) => List.generate(
        maxLength(i),
        (index) => BarChartGroupData(
          x: (index + 1),
          barRods: [
            BarChartRodData(
              toY: random.nextInt(100).toDouble(),
              fromY: 0,
              width: 25.w,
              color: primary,
              borderRadius: BorderRadius.circular(7.5.r),
            ),
          ],
        ),
      ),
    );
  }

  int maxLength(int index) {
    int length = 0;
    if (index <= 1) {
      length = 7;
    } else if (index <= 3) {
      DateTime currentDate = DateTime.now();
      late int days;
      if (index == 2) {
        days = getDaysOfMonth(currentDate.month, currentDate.year);
      } else {
        if (currentDate.month == 1) {
          days = getDaysOfMonth(DateTime.monthsPerYear, currentDate.year - 1);
        } else {
          days = getDaysOfMonth(currentDate.month - 1, currentDate.year);
        }
      }
      length = days == 28 ? 4 : 5;
    } else {
      length = 3;
    }
    return length;
  }

  String get bottomAxisTitle {
    if (currentFilterIndex <= 1) {
      return "Days";
    } else if (currentFilterIndex <= 3) {
      return "Weeks";
    }
    return "Months";
  }

  @override
  Widget build(BuildContext context) {
    double revenue = (ref.watch(userProvider) as Attendant).balance;

    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: ListView.separated(
            itemBuilder: (_, index) {
              bool selected = currentFilterIndex == index;
              return GestureDetector(
                onTap: () => setState(() => currentFilterIndex = index),
                child: Chip(
                  label: Text(
                    filterOptions[index],
                    style: context.textTheme.bodySmall!.copyWith(
                      fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                  backgroundColor:
                      selected ? secondary : primary50.withOpacity(0.2),
                  elevation: selected ? 1.0 : 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.5.r),
                  ),
                  side: const BorderSide(color: Colors.transparent),
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemCount: filterOptions.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
          ),
        ),
        SizedBox(height: 10.h),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 30,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 20.h,
              bottom: 5.h,
              right: 20.w,
              left: 20.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Revenue",
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "₦${formatAmount(revenue.toStringAsFixed(0))}",
                          style: context.textTheme.displaySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        if (change != 0.0)
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: change > 0
                                  ? Colors.lightGreenAccent.withOpacity(0.5)
                                  : Colors.redAccent.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.r),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${change.toStringAsFixed(1)}%",
                                    style:
                                        context.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: change > 0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Icon(
                                    change > 0
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded,
                                    size: 12.r,
                                    color:
                                        change > 0 ? Colors.green : Colors.red,
                                  )
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 375.w,
                  height: 300.h,
                  child: BarChart(
                    BarChartData(
                      minY: 0,
                      maxY: 100,
                      alignment: BarChartAlignment.spaceBetween,
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: const SideTitles(showTitles: true),
                          axisNameSize: 40,
                          axisNameWidget: Text(
                            bottomAxisTitle,
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      gridData: const FlGridData(
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: barData[currentFilterIndex],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class OrderContainer extends StatelessWidget {
  final Order order;

  const OrderContainer({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.pushNamed(
        Pages.viewAttendantOrder,
        extra: order,
      ),
      child: Container(
        height: 200.h,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.5.r),
                image: DecorationImage(
                  image: AssetImage(order.riderImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              order.riderName,
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: monokai,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  order.code,
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: monokai,
                  ),
                ),
                Text(
                  "Rider",
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: secondary,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Cylinder size:",
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: monokai,
                  ),
                ),
                Text(
                  "${order.cylinderSize}kg",
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: monokai,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WalletSlider extends ConsumerStatefulWidget {
  const WalletSlider({super.key});

  @override
  ConsumerState<WalletSlider> createState() => _WalletSliderState();
}

class _WalletSliderState extends ConsumerState<WalletSlider> {
  bool showBalance = true;

  @override
  Widget build(BuildContext context) {
    double revenue = (ref.watch(userProvider) as Attendant).balance;

    return Container(
      width: 375.w,
      height: 120.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Available Balance",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => showBalance = !showBalance),
                child: AnimatedSwitcherZoom.zoomIn(
                  duration: const Duration(milliseconds: 500),
                  child: Icon(
                    showBalance
                        ? IconsaxPlusBroken.eye
                        : IconsaxPlusBroken.eye_slash,
                    color: Colors.white,
                    size: 26.r,
                    key: ValueKey<bool>(
                      showBalance,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 25.h),
          AnimatedSwitcherTranslation.top(
            duration: const Duration(milliseconds: 500),
            child: Text(
              showBalance
                  ? "₦${formatAmount(revenue.toStringAsFixed(0))}"
                  : "********",
              key: ValueKey<bool>(showBalance),
              style: context.textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SaleReportContainer extends StatefulWidget {
  final SaleReport report;

  const SaleReportContainer({
    super.key,
    required this.report,
  });

  @override
  State<SaleReportContainer> createState() => _SaleReportContainerState();
}

class _SaleReportContainerState extends State<SaleReportContainer>
    with SingleTickerProviderStateMixin {
  bool expanded = false;

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
