import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/driver.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewDriverOrder extends ConsumerStatefulWidget {
  final Order order;

  const ViewDriverOrder({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<ViewDriverOrder> createState() => _ViewDriverOrderState();
}

class _ViewDriverOrderState extends ConsumerState<ViewDriverOrder> {
  @override
  Widget build(BuildContext context) {
    List<Order> orders = ref.watch(driverOrdersProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "View Order",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  dividerColor: Colors.transparent,
                  labelStyle: context.textTheme.titleMedium,
                  tabs: const [
                    Tab(text: "Order Details"),
                    Tab(text: "Track Order"),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            GasOrderDetail(order: widget.order),
                            SizedBox(height: 20.h),
                            UserOrderDetail(order: widget.order),
                            SizedBox(height: 20.h),
                            MerchantOrderDetail(order: widget.order),
                          ],
                        ),
                      ),
                      CustomOrderStepper(
                        order: widget.order,
                        onUpdateState: (order) {
                          int index =
                              orders.indexWhere((o) => o.id == widget.order.id);
                          List<Order> pre = orders.sublist(0, index);
                          List<Order> post = orders.sublist(index + 1);
                          ref.watch(driverOrdersProvider.notifier).state = [
                            ...pre,
                            order,
                            ...post,
                          ];
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
