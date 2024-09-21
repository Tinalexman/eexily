import 'dart:math';

import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
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
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Likely running out on ",
                        style: context.textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: "May 31st, 2002",
                        style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
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
