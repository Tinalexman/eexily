import 'package:eexily/components/order.dart';
import 'package:eexily/pages/home/support/details.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewSupportOrder extends StatefulWidget {
  final Order order;

  const ViewSupportOrder({
    super.key,
    required this.order,
  });

  @override
  State<ViewSupportOrder> createState() => _ViewSupportOrderState();
}

class _ViewSupportOrderState extends State<ViewSupportOrder> {
  late Color background, text;

  @override
  void initState() {
    super.initState();
    background = randomColor(widget.order.code);
    text = chooseTextColor(background);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Order",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  labelColor: primary,
                  labelStyle: context.textTheme.bodyLarge,
                  unselectedLabelColor: neutral2,
                  indicatorColor: primary,
                  tabs: const [
                    Tab(text: "Details"),
                    Tab(text: "Track Order"),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Column(
                          children: [
                            OrderDetails(
                              order: widget.order,
                              background: background,
                              text: text,
                            ),
                            SizedBox(height: 20.h),
                            RiderOrderDetail(order: widget.order),
                          ],
                        ),
                      ),
                      TrackOrder(order: widget.order),
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
