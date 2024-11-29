import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewMerchantOrder extends ConsumerStatefulWidget {
  final Order order;

  const ViewMerchantOrder({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<ViewMerchantOrder> createState() => _ViewMerchantOrderState();
}

class _ViewMerchantOrderState extends ConsumerState<ViewMerchantOrder> {
  @override
  Widget build(BuildContext context) {
    List<Order> orders = ref.watch(merchantOrdersProvider);

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
                            RiderOrderDetail(order: widget.order),
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
                          ref.watch(merchantOrdersProvider.notifier).state = [
                            ...pre,
                            order,
                            ...post,
                          ];

                          // Order order = userOrders.first;
                          // List<OrderStates> states = order.states;
                          // bool canProceed =
                          // canProceedTo(order.status, notification.notificationType);
                          // if (canProceed) {
                          //   OrderState newState = convertState(notification.notificationType);
                          //   states.add(
                          //     OrderStates(
                          //       state: newState,
                          //       timestamp: notification.timestamp.toIso8601String(),
                          //     ),
                          //   );
                          //   ref.watch(initialExpressOrdersProvider.notifier).state = [
                          //     order.copyWith(
                          //       status: notification.notificationType,
                          //       states: states,
                          //     ),
                          //     ...(userOrders.sublist(1)),
                          //   ];
                          // }
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
