import 'dart:math';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/sale_report.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
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
    double revenue = ref.watch(revenueProvider);

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

class WalletSlider extends ConsumerStatefulWidget {
  const WalletSlider({super.key});

  @override
  ConsumerState<WalletSlider> createState() => _WalletSliderState();
}

class _WalletSliderState extends ConsumerState<WalletSlider> {
  bool showBalance = true;

  @override
  Widget build(BuildContext context) {
    double revenue = 0;//(ref.watch(userProvider) as Attendant).balance;

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

  double total = 0.0;

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
    Future.delayed(Duration.zero, getTotal);
  }

  void getTotal() {
    for (Order order in widget.report.orders) {
      total += order.price;
    }
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Sale Report for ${formatDateRaw(widget.report.timestamp, shorten: true)}",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: monokai,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.report.orders.isNotEmpty)
                IconButton(
                  onPressed: () {
                    setState(() => expanded = !expanded);
                    if (expanded) {
                      controller.forward();
                    } else {
                      controller.reverse();
                    }
                  },
                  icon: AnimatedSwitcherTranslation.right(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      expanded
                          ? IconsaxPlusBroken.arrow_up_1
                          : IconsaxPlusBroken.arrow_down,
                      color: monokai,
                      key: ValueKey<bool>(expanded),
                    ),
                  ),
                  iconSize: 26.r,
                )
            ],
          ),
          Text(
            "₦${formatAmount(total.toStringAsFixed(0))}",
            style: context.textTheme.titleLarge!.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          if (widget.report.orders.isNotEmpty)
            SizeTransition(
              sizeFactor: animation,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "G-Code",
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: monokai,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "Gas Quantity",
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: monokai,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "Amount",
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: monokai,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: List.generate(
                      widget.report.orders.length,
                      (index) {
                        Order order = widget.report.orders[index];
                        double gasQuantity =
                            order.price / widget.report.retailPrice;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  order.code,
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: monokai,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "${gasQuantity.toStringAsFixed(1)}kg",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: monokai,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "₦${formatAmount(order.price.toStringAsFixed(0))}",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: monokai,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class SalePriceContainer extends StatefulWidget {
  final String label;
  final double price;
  final Function onPriceUpdated;

  const SalePriceContainer({
    super.key,
    required this.label,
    required this.price,
    required this.onPriceUpdated,
  });

  @override
  State<SalePriceContainer> createState() => _SalePriceContainerState();
}

class _SalePriceContainerState extends State<SalePriceContainer> {
  void showModal() {
    showDialog(
      context: context,
      builder: (context) => _PriceUpdate(
        price: widget.price,
        onUpdate: widget.onPriceUpdated,
      ),
      useSafeArea: true,
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.label,
            style: context.textTheme.labelLarge!.copyWith(
              color: monokai,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "₦${formatAmount(widget.price.toStringAsFixed(0))}",
            style: context.textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            onTap: showModal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Edit",
                  style: context.textTheme.bodySmall,
                ),
                SizedBox(width: 2.w),
                Icon(
                  IconsaxPlusBroken.edit,
                  size: 12.r,
                  color: monokai,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceUpdate extends StatefulWidget {
  final double price;
  final Function onUpdate;

  const _PriceUpdate({
    super.key,
    required this.price,
    required this.onUpdate,
  });

  @override
  State<_PriceUpdate> createState() => _PriceUpdateState();
}

class _PriceUpdateState extends State<_PriceUpdate> {
  late TextEditingController controller;
  FocusNode node = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.price.toStringAsFixed(0));
    node.requestFocus();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 80.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Price update",
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h),
              SpecialForm(
                controller: controller,
                width: 160.w,
                focus: node,
                type: TextInputType.number,
                hint: "New price",
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      "Cancel",
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String text = controller.text.trim();
                      double? value = double.tryParse(text);
                      if (text.isEmpty || value == null) return;

                      widget.onUpdate(value);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Update",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}

class GasOrderDetail extends StatelessWidget {
  final Order order;
  final double retailPrice;

  const GasOrderDetail({
    super.key,
    required this.order,
    required this.retailPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      width: 375.w,
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
          Text(
            "Order #${order.id}",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: monokai,
            ),
          ),
          Text(
            order.status.name.capitalize,
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: order.status == OrderStatus.pending ? secondary : primary,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                "assets/images/Two Cylinders.png",
                width: 120.w,
                height: 180.h,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: Container(
                  width: 180.w,
                  decoration: BoxDecoration(
                    color: primary50.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(7.5.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Price:",
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: monokai,
                            ),
                          ),
                          Text(
                            "₦${formatAmount(order.price.toStringAsFixed(0))}",
                            style: context.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: monokai,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Quantity:",
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: monokai,
                            ),
                          ),
                          Text(
                            "${(order.price / retailPrice).toStringAsFixed(1)}kg",
                            style: context.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: monokai,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
