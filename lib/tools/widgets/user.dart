import 'dart:math';

import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserGasUsageGraph extends ConsumerStatefulWidget {
  const UserGasUsageGraph({super.key});

  @override
  ConsumerState<UserGasUsageGraph> createState() => _UserGasUsageGraphState();
}

class _UserGasUsageGraphState extends ConsumerState<UserGasUsageGraph> {
  final List<String> filterOptions = [
    "This week",
    "Last week",
    "This month",
    "Last month",
    "Last 3 months",
  ];

  int currentFilterIndex = 0;

  late List<List<FlSpot>> lineChartData = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    List<List<FlSpot>> newData = List.generate(
      filterOptions.length,
      (i) {
        Random random = Random(DateTime.now().millisecondsSinceEpoch + i);
        int min = 50, max = random.nextInt(250);
        return List.generate(
          maxLength(i),
          (index) => FlSpot(
            (index + 1).toDouble(),
            (max + min).toDouble(),
          ),
        );
      },
    );
    lineChartData.addAll(newData);
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

  double get maxValue {
    double max = 0.0;
    for (var spot in lineChartData[currentFilterIndex]) {
      if (spot.y >= max) {
        max = spot.y;
      }
    }
    return max + 20;
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Gas Usage",
                style: context.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "History",
                style: context.textTheme.bodyMedium!.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
          SizedBox(
            width: 375.w,
            height: 230.h,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxValue,
                minX: 1,
                maxX: maxLength(currentFilterIndex).toDouble(),
                clipData: const FlClipData.horizontal(),
                backgroundColor: Colors.transparent,
                gridData: const FlGridData(
                  drawHorizontalLine: false,
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1.0,
                      getTitlesWidget: (index, meta) {
                        return Text(
                          convertIndexName(index.toInt()),
                          style: context.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    color: primary,
                    gradient: const LinearGradient(
                      colors: [
                        primary,
                        primary,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    belowBarData: BarAreaData(
                      color: primary,
                      show: true,
                      gradient: const LinearGradient(
                        colors: [primary50, primary50],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    shadow: const Shadow(
                      color: primary50,
                    ),
                    isCurved: true,
                    isStrokeCapRound: true,
                    curveSmoothness: 0.75,
                    spots: lineChartData[currentFilterIndex],
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ),
          )
        ],
      ),
    );
  }
}

class UserGasStatistics extends ConsumerStatefulWidget {
  const UserGasStatistics({super.key});

  @override
  ConsumerState<UserGasStatistics> createState() => _UserGasStatisticsState();
}

class _UserGasStatisticsState extends ConsumerState<UserGasStatistics> {
  late DateTime likelyRunningOutDate;

  int cylinderSize = 12;

  @override
  void initState() {
    super.initState();
    likelyRunningOutDate = DateTime(2024, 5, 31);
  }

  Color gasColor(double value) {
    if (value >= 0.70) {
      return secondary2;
    } else if (value >= 0.25 && value < 0.7) {
      return secondary;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    int level = ref.watch(gasLevelProvider);

    return DecoratedBox(
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
                  Text(
                    "$level%",
                    style: context.textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Cylinder Size",
                        style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${cylinderSize}kg",
                        style: context.textTheme.bodyLarge!.copyWith(
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
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Likely finishing on ",
                      style: context.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: formatDateRaw(likelyRunningOutDate, shorten: true),
                      style: context.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}
