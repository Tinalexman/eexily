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
    background = randomColor(widget.order.code);
    text = chooseTextColor(background);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.pushNamed(
        Pages.viewOrder,
        extra: widget.order,
      ),
      child: Container(
        width: 375.w,
        height: 70.h,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.5.r),
          color: const Color(0xFFD9D9D9).withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundImage: widget.order.riderImage != null
                      ? AssetImage(widget.order.riderImage!)
                      : null,
                  backgroundColor:
                      widget.order.riderImage == null ? background : null,
                  child: widget.order.riderImage == null
                      ? Center(
                          child: Text(
                            widget.order.riderName.substring(0, 1),
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: text,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.order.riderName,
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.order.deliveryIssue,
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                )
              ],
            ),
            Text(
              widget.order.code,
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
