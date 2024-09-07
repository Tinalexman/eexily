import 'package:eexily/components/order.dart';
import 'package:eexily/pages/home/support/details.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewOrder extends StatefulWidget {
  final Order order;

  const ViewOrder({
    super.key,
    required this.order,
  });

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
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
          style: context.textTheme.titleMedium!.copyWith(
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
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "G-Code: ",
                      style: context.textTheme.titleSmall,
                    ),
                    TextSpan(
                      text: widget.order.code,
                      style: context.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ]),
                ),
                SizedBox(height: 10.h),
                TabBar(
                  dividerColor: const Color(0xFF898A8D).withOpacity(0.5),
                  labelStyle: context.textTheme.bodyLarge,
                  tabs: const [
                    Tab(text: "Details"),
                    Tab(text: "Track Order"),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: TabBarView(
                    children: [
                      OrderDetails(
                        order: widget.order,
                        background: background,
                        text: text,
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
