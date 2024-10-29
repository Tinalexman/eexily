import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndividualOrderHistory extends ConsumerStatefulWidget {
  const IndividualOrderHistory({super.key});

  @override
  ConsumerState<IndividualOrderHistory> createState() => _IndividualOrderHistoryState();
}

class _IndividualOrderHistoryState extends ConsumerState<IndividualOrderHistory> {
  @override
  Widget build(BuildContext context) {
    List<UserOrder> orders = ref.watch(previousUserOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Order History",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView.separated(
            itemBuilder: (_, index) {
              if(index == orders.length) {
                return SizedBox(height: 20.h);
              }

              UserOrder order = orders[index];

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
                      "Order #${order.id}",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Delivered to: ",
                            style: context.textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: "",
                            style: context.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Amount of gas ordered: ",
                            style: context.textTheme.bodySmall,
                          ),
                          TextSpan(
                            text:
                            "${order.quantity}kg",
                            style: context.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Amount paid: ",
                            style: context.textTheme.bodySmall,
                          ),
                          TextSpan(
                            text:
                            "₦${formatAmount("${order.price}")}",
                            style: context.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Delivered on: ",
                            style: context.textTheme.bodySmall,
                          ),
                          // TextSpan(
                          //   text:
                          //   formatDateRawWithTime(order.states.last.timestamp),
                          //   style: context.textTheme.bodySmall!.copyWith(
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemCount: orders.length + 1,
          ),
        ),
      ),
    );
  }
}
