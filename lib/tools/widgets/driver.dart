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
        height: 70.h,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: background,
              child: Center(
                child: Text(
                  widget.order.name.substring(0, 1),
                  style: context.textTheme.titleLarge!.copyWith(
                    color: text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.order.name,
                  style: context.textTheme.titleMedium!.copyWith(
                    color: monokai,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.order.code,
                  style: context.textTheme.titleSmall!.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Text(
            //   formatDateRaw(widget.order.deliveryDate, shorten: true),
            //   style: context.textTheme.bodyMedium!.copyWith(
            //     color: monokai,
            //     fontWeight: FontWeight.w400,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
