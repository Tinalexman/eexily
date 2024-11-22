import 'package:eexily/api/refill.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/driver.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getRiderOrders);
  }

  Future<void> getRiderOrders() async {
    String id = ref.watch(userProvider.select((u) => u.id));
    var response = await getDriverScheduledIncomingOrders(id);
    showMessage(response.message);
    setState(() => loading = false);
    if (!response.status) return;

    ref.watch(driverOrdersProvider.notifier).state = response.payload;
  }

  void showMessage(String message) => showToast(message, context);

  @override
  Widget build(BuildContext context) {
    List<Order> driverOrders =
        loading ? dummyOrders : ref.watch(driverOrdersProvider);
    bool canShowData = loading || driverOrders.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text(
          "Orders of the day",
          style: context.textTheme.bodyLarge!.copyWith(
            color: monokai,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        if (!canShowData)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/error.png",
                    width: 200.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "You do not have any incoming orders",
                    style: context.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      setState(() => loading = true);
                      getRiderOrders();
                    },
                    child: Text(
                      "Click here to refresh",
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        if (canShowData)
          Expanded(
            child: Skeletonizer(
              enabled: loading,
              child: ListView.separated(
                itemBuilder: (_, index) =>
                    d.OrderContainer(order: driverOrders[index]),
                padding: const EdgeInsets.all(1),
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemCount: driverOrders.length,
                physics: const BouncingScrollPhysics(),
              ),
            ),
          )
      ],
    );
  }
}
