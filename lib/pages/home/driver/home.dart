import 'package:eexily/api/refill.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/driver.dart' as d;
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/driver.dart' as wd;
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
  bool loading = false;

  String id = "";
  d.Type driverType = d.Type.nil;

  @override
  void initState() {
    super.initState();
    d.Driver driver = ref.read(userProvider) as d.Driver;
    id = driver.id;
    driverType = driver.type;
    // loading = true;
    // Future.delayed(Duration.zero, getOrders);
  }

  Future<void> getOrders() async {
    if (driverType == d.Type.nil) {
      showMessage("Invalid role");
      setState(() => loading = false);
      return;
    }

    var response = (driverType == d.Type.rider)
        ? (await getRiderExpressIncomingOrders(id))
        : (await getDriverScheduledIncomingOrders(id));
    showMessage(
      response.message,
      response.status ? primary : null,
    );
    setState(() => loading = false);
    if (!response.status) return;

    ref.watch(driverOrdersProvider.notifier).state = response.payload;
  }

  void showMessage(String message, [Color? color]) => showToast(
        message,
        context,
        backgroundColor: color,
      );

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
          style: context.textTheme.titleLarge!.copyWith(
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
                  SizedBox(height: 50.h),
                  Image.asset(
                    "assets/images/error.png",
                    width: 200.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Oops :(",
                    style: context.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "You do not have any incoming orders.",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontFamily: "WorkSans",
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      setState(() => loading = true);
                      getOrders();
                    },
                    child: Text(
                      "Click to Refresh",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontFamily: "WorkSans",
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 100.h),
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
                    wd.OrderContainer(order: driverOrders[index]),
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
