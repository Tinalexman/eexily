import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/main.dart';
import 'package:eexily/pages/home/support/details.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
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
  late double price;

  @override
  void initState() {
    super.initState();
    Attendant attendant = ref.read(userProvider) as Attendant;
    price = attendant.retailGasPrice;
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
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Container(
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
                      "Order #${widget.order.id}",
                      style: context.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: monokai,
                      ),
                    ),
                    Text(
                      widget.order.status.name.capitalize,
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: widget.order.status == OrderStatus.pending ? secondary : primary,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Two Cylinders.png",
                          width: 120.w,
                          height: 180.h,
                          fit: BoxFit.cover,
                        ),
                        Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Retail Price:",
                                    style:
                                        context.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: monokai,
                                    ),
                                  ),
                                  Text(
                                    "₦${formatAmount(price.toStringAsFixed(0))}",
                                    style:
                                        context.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: monokai,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Quantity:",
                                    style:
                                        context.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: monokai,
                                    ),
                                  ),
                                  Text(
                                    widget.order.cylinderSize
                                        .toStringAsFixed(0),
                                    style:
                                        context.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: monokai,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Discount:",
                                    style:
                                        context.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: monokai,
                                    ),
                                  ),
                                  Text(
                                    "₦0",
                                    style:
                                        context.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: monokai,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total:",
                                    style:
                                        context.textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: monokai,
                                    ),
                                  ),
                                  Text(
                                    "₦${format(price * widget.order.cylinderSize)}",
                                    style:
                                        context.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: monokai,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                height: 140.h,
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
                    Text(
                      "Rider",
                      style: context.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: monokai,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80.h,
                          width: 80.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.5.r),
                            image: DecorationImage(
                              image: AssetImage(widget.order.riderImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.order.riderName,
                              style: context.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: monokai,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "G-Code: ${widget.order.code}",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: monokai,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "Vehicle Number: ${widget.order.riderBike}",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: monokai,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
