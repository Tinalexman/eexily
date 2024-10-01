import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
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

              return SizedBox();
            },
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemCount: orders.length + 1,
          ),
        ),
      ),
    );
  }
}
