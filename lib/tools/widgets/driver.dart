import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderContainer extends StatefulWidget {
  final Order order;

  const OrderContainer({
    super.key,
    required this.order,
  });

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  late Color background, text;

  @override
  void initState() {
    super.initState();
    background = randomColor(widget.order.name);
    text = chooseTextColor(background);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.pushNamed(
        Pages.viewDriverOrder,
        extra: widget.order,
      ),
      child: Container(
        width: 375.w,
        height: 100.h,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80.h,
              height: 80.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(7.5.r),
              ),
              child: Text(
                widget.order.name.substring(0, 1),
                style: context.textTheme.headlineMedium!.copyWith(
                  color: text,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order #${widget.order.id}",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: monokai,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "User Code: ",
                        style: context.textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: widget.order.code,
                        style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: primary,
                        ),
                      )
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Gas Quantity: ",
                        style: context.textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: "${widget.order.gasQuantity}kg",
                        style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Delivery Time: ",
                        style: context.textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: convertTime(widget.order.deliveryDate),
                        style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
