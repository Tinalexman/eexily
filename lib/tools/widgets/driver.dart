import 'package:cached_network_image/cached_network_image.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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
    background = randomColor(widget.order.metadata.userName);
    text = chooseTextColor(background);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.pushNamed(
        Pages.viewDriverOrder,
        extra: widget.order,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: getUniqueImageUrl(widget.order.metadata.userName),
              errorWidget: (_, __, ___) {
                return CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.redAccent,
                  child: Icon(
                    IconsaxPlusBold.gallery_slash,
                    size: 32.r,
                    color: Colors.white,
                  ),
                );
              },
              progressIndicatorBuilder: (_, __, ___) {
                return CircleAvatar(
                  radius: 24.r,
                  backgroundColor: primary50,
                );
              },
              imageBuilder: (_, provider) {
                return CircleAvatar(
                  radius: 24.r,
                  backgroundColor: primary50.withOpacity(0.5),
                  backgroundImage: provider,
                );
              },
            ),
            SizedBox(
              height: 48.r,
              width: 200.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.order.metadata.userName,
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: monokai,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "G-Code: ${widget.order.code}",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: background,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48.r,
              width: 60.r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${widget.order.quantity}kg",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: monokai,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    convertTime(DateTime.parse(widget.order.createdAt)),
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: monokai,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
