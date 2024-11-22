import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewAttendantOrder extends ConsumerStatefulWidget {
  final Order order;

  const ViewAttendantOrder({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<ViewAttendantOrder> createState() => _ViewAttendantOrderState();
}

//<a href="https://www.vecteezy.com/free-vector/gas-cylinder">Gas Cylinder Vectors by Vecteezy</a>

class _ViewAttendantOrderState extends ConsumerState<ViewAttendantOrder> {
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    double retailPrice = (ref.read(userProvider) as Attendant).retailGasPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Order",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              GasOrderDetail(order: widget.order),
              SizedBox(height: 20.h),
              RiderOrderDetail(order: widget.order),
              SizedBox(height: 200.h),
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
                    "Complete Order",
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
    );
  }
}
