import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewDriverOrder extends StatefulWidget {
  final Order order;

  const ViewDriverOrder({
    super.key,
    required this.order,
  });

  @override
  State<ViewDriverOrder> createState() => _ViewDriverOrderState();
}

class _ViewDriverOrderState extends State<ViewDriverOrder> {
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Order Details",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                GasOrderDetail(order: widget.order),
                SizedBox(height: 350.h),
                if (!completed)
                  ElevatedButton(
                    onPressed: () => setState(() => completed = true),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(330.w, 50.h),
                      fixedSize: Size(330.w, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.5.r),
                      ),
                      elevation: 1.0,
                      backgroundColor: primary,
                    ),
                    child: Text(
                      "Mark as Delivered",
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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
