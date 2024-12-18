import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewAttendantOrder extends StatefulWidget {
  final Order order;

  const ViewAttendantOrder({
    super.key,
    required this.order,
  });

  @override
  State<ViewAttendantOrder> createState() => _ViewDriverOrderState();
}

class _ViewDriverOrderState extends State<ViewAttendantOrder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "View Order",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  dividerColor: Colors.transparent,
                  labelStyle: context.textTheme.titleMedium,
                  tabs: const [
                    Tab(text: "Order Details"),
                    Tab(text: "Track Order"),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            GasOrderDetail(order: widget.order),
                            SizedBox(height: 20.h),
                            UserOrderDetail(order: widget.order),
                            SizedBox(height: 20.h),
                            RiderOrderDetail(order: widget.order),
                          ],
                        ),
                      ),
                      CustomOrderStepper(
                        widgetOrder: widget.order,
                        onUpdateState: (order) {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
