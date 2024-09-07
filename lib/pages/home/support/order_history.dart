import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderHistory extends ConsumerStatefulWidget {
  const OrderHistory({super.key});

  @override
  ConsumerState<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends ConsumerState<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    List<Order> history = ref.watch(orderHistoryProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "History",
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      if (index == history.length) {
                        return SizedBox(height: 50.h);
                      }

                      return OrderContainer(order: history[index]);
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 15.h),
                    itemCount: history.length + 1,
                    physics: const BouncingScrollPhysics(),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
