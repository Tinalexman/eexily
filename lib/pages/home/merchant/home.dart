import 'package:eexily/api/merchant.dart';
import 'package:eexily/api/refill.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/merchant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    Future.delayed(Duration.zero, getOrders);
  }

  Future<void> getOrders() async {
    String merchantId = ref.watch(userProvider.select((r) => r.id));
    var response = await getMerchantExpressOrders(merchantId);
    setState(() => loading = false);

    if(!response.status) {
      showMessage(response.message);
      return;
    }

    ref.watch(merchantOrdersProvider.notifier).state = response.payload;
  }

  void showMessage(String message) => showToast(message, context);

  @override
  Widget build(BuildContext context) {
    Merchant merchant = ref.watch(userProvider) as Merchant;
    List<Order> orders = ref.watch(merchantOrdersProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 220.w,
                    child: Text(
                      merchant.storeName,
                      style: context.textTheme.titleLarge!.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        merchant.isOpened ? "Opened" : "Closed",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: monokai,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.75,
                        child: Switch(
                          value: merchant.isOpened,
                          onChanged: (val) {},
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 5.h),
              const RevenueChart(),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: "Incoming Orders Tag",
                    child: Text(
                      "Incoming Orders",
                      style: context.textTheme.titleMedium!.copyWith(
                        color: monokai,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (orders.length > 2)
                    GestureDetector(
                      onTap: () =>
                          context.router.pushNamed(Pages.allAttendantOrders),
                      child: Text(
                        "View all",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 165.h,
                    crossAxisSpacing: 20.h,
                  ),
                  itemBuilder: (_, index) => OrderContainer(
                    order: orders[index],
                    link: Pages.viewMerchantOrder,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: orders.length < 2 ? orders.length : 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
