import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Name: ",
                style: context.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: order.name,
                style: context.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Phone number: ",
                style: context.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: order.phone,
                style: context.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Address: ",
                style: context.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: order.address,
                style: context.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Cylinder size: ",
                style: context.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: "${order.cylinderSize.toStringAsFixed(0)}kg",
                style: context.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Delivery date: ",
                style: context.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: formatDateRaw(order.deliveryDate),
                style: context.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Delivery status: ",
                style: context.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: order.status.name.capitalize,
                style: context.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 30.h),
        Text(
          "Rider",
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundImage: order.riderImage != null
                      ? AssetImage(order.riderImage!)
                      : null,
                  backgroundColor: order.riderImage == null ? background : null,
                  child: order.riderImage == null
                      ? Center(
                          child: Text(
                            order.riderName.substring(0, 1),
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: text,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      order.riderName,
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Bike Number: ${order.riderBike}",
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.phone_outlined,
                    color: primary,
                  ),
                  iconSize: 26.r,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.message_rounded,
                    color: primary,
                  ),
                  iconSize: 26.r,
                )
              ],
            ),
          ],
        )
      ],
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

