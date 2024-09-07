import 'dart:math';

import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final List<String> filterOptions = [
    "This week",
    "Last week",
    "This month",
    "Last month",
    "Last 3 months",
  ];

  int currentFilterIndex = 0;
  double revenue = 250035;

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
    Attendant attendant = ref.watch(userProvider) as Attendant;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                attendant.gasStation,
                style: context.textTheme.titleLarge!.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.h),
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
                            fontWeight:
                                selected ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                        backgroundColor:
                            selected ? secondary : primary50.withOpacity(0.2),
                        elevation: selected ? 1.0 : 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
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
                          Text(
                            "₦${formatAmount(revenue.toStringAsFixed(0))}",
                            style: context.textTheme.displaySmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
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
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Orders",
                    style: context.textTheme.titleMedium!.copyWith(
                      color: monokai,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "View all",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
