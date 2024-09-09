import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetails extends StatelessWidget {
  final Order order;
  final Color background, text;

  const OrderDetails({
    super.key,
    required this.order,
    required this.background,
    required this.text,
  });

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
          Text(
            "Customer",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: monokai,
            ),
          ),
          SizedBox(height: 15.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Name: ",
                  style: context.textTheme.bodySmall!.copyWith(
                    color: monokai,
                  ),
                ),
                TextSpan(
                  text: order.name,
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: monokai,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Phone number: ",
                  style: context.textTheme.bodySmall!.copyWith(
                    color: monokai,
                  ),
                ),
                TextSpan(
                  text: order.phone,
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: monokai,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Address: ",
                  style: context.textTheme.bodySmall!.copyWith(
                    color: monokai,
                  ),
                ),
                TextSpan(
                  text: order.address,
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: monokai,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Gas Ordered: ",
                  style: context.textTheme.bodySmall!.copyWith(
                    color: monokai,
                  ),
                ),
                TextSpan(
                  text: "₦${formatAmount(order.price.toStringAsFixed(0))}",
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: monokai,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Delivery date: ",
                  style: context.textTheme.bodySmall!.copyWith(
                    color: monokai,
                  ),
                ),
                TextSpan(
                  text: formatDateRaw(order.deliveryDate, shorten: true,),
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: monokai,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Delivery status: ",
                  style: context.textTheme.bodySmall!.copyWith(
                    color: monokai,
                  ),
                ),
                TextSpan(
                  text: order.status.name.capitalize,
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: order.status == OrderStatus.pending ? secondary : primary,
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

class TrackOrder extends StatelessWidget {
  final Order order;
  const TrackOrder({super.key, required this.order,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

      ],
    );
  }
}

