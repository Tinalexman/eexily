import 'package:eexily/components/order.dart';
import 'package:eexily/pages/home/attendant/widgets.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendantAllOrdersPage extends ConsumerStatefulWidget {
  const AttendantAllOrdersPage({super.key});

  @override
  ConsumerState<AttendantAllOrdersPage> createState() =>
      _AttendantAllOrdersPageState();
}

class _AttendantAllOrdersPageState
    extends ConsumerState<AttendantAllOrdersPage> {
  @override
  Widget build(BuildContext context) {
    List<Order> orders = ref.watch(attendantOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "Incoming Orders Tag",
          flightShuttleBuilder: heroShuttleBuilder,
          child: Text(
            "Orders",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GridView.builder(
            padding: const EdgeInsets.all(1),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 165.h,
              crossAxisSpacing: 10.h,
              mainAxisSpacing: 10.h,
            ),
            itemBuilder: (_, index) => OrderContainer(order: orders[index]),
            physics: const BouncingScrollPhysics(),
            itemCount: orders.length,
          ),
        ),
      ),
    );
  }
}
