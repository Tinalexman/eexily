import 'dart:math';

import 'package:eexily/components/usage.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GasUsagePage extends StatefulWidget {
  const GasUsagePage({super.key});

  @override
  State<GasUsagePage> createState() => _GasUsagePageState();
}

class _GasUsagePageState extends State<GasUsagePage> {
  final List<String> filterOptions = [
    "This week",
    "Last week",
    "This month",
    "Last month",
    "Last 3 months",
  ];

  int currentFilterIndex = 0;

  late List<List<BarChartGroupData>> barData;
  double maxYValue = 12.0;

  final List<UsageData> usages = [];

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
        (index) {
          double toY = random.nextInt(12).toDouble();
          // if (toY > maxYValue) {
          //   maxYValue = toY;
          // }

          return BarChartGroupData(
            x: (index + 1),
            barRods: [
              BarChartRodData(
                toY: toY,
                fromY: 0,
                width: 25.w,
                color: primary,
                borderRadius: BorderRadius.circular(7.5.r),
              ),
            ],
          );
        },
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

  String convertIndexName(int index) {
    if (currentFilterIndex <= 1) {
      return getWeekDay(index, shorten: true);
    } else if (currentFilterIndex <= 3) {
      return "Week $index";
    }
    DateTime threeMonthsAgo = DateUtilities.getThreeMonthsAgoStart();
    return month("${threeMonthsAgo.month + index - 1}", true);
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
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0.0,
              title: Text(
                "Gas Usage",
                style: context.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              pinned: true,
              floating: true,
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50.h,
                      child: ListView.separated(
                        itemBuilder: (_, index) {
                          bool selected = currentFilterIndex == index;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => currentFilterIndex = index),
                            child: Chip(
                              label: Text(
                                filterOptions[index],
                                style: context.textTheme.bodySmall!.copyWith(
                                  fontWeight: selected
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                ),
                              ),
                              backgroundColor: selected
                                  ? secondary
                                  : primary50.withOpacity(0.2),
                              elevation: selected ? 1.0 : 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.5.r),
                              ),
                              side: const BorderSide(color: Colors.transparent),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(width: 15.w),
                        itemCount: filterOptions.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                      ),
                    ),
                    SizedBox(height: 50.h),
                    SizedBox(
                      width: 375.w,
                      height: 300.h,
                      child: BarChart(
                        BarChartData(
                          minY: 0,
                          maxY: maxYValue,
                          alignment: BarChartAlignment.spaceBetween,
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: const SideTitles(
                                showTitles: true,
                                interval: 2.0,
                                minIncluded: false,
                                maxIncluded: true,
                              ),
                              axisNameWidget: Text(
                                "Amount of gas used (kg)",
                                style: context.textTheme.bodyMedium,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (index, meta) {
                                  return Text(
                                    convertIndexName(index.toInt()),
                                    style: context.textTheme.bodySmall,
                                  );
                                },
                              ),
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
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "History",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverList.separated(
                itemBuilder: (_, __) => SizedBox(

                ),
                itemCount: usages.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
