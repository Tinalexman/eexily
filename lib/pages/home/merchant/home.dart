import 'package:eexily/api/merchant.dart';
import 'package:eexily/api/refill.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/merchant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/gestures.dart';
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
    Future.delayed(Duration.zero, getOrders);
  }

  Future<void> getOrders() async {
    String merchantId = ref.watch(userProvider.select((r) => r.id));
    var response = await getMerchantExpressOrders(merchantId);
    setState(() => loading = false);

    if (!response.status) {
      showMessage(response.message);
      return;
    }

    ref.watch(merchantOrdersProvider.notifier).state = response.payload;
  }

  Future<void> modifyStore(bool active) async {
    Merchant merchant = ref.watch(userProvider) as Merchant;
    var response = await updateMerchantUser({"isOpened": active}, merchant.id);
    setState(() => loading = false);

    if (!response.status) {
      showMessage(response.message);
      ref.watch(userProvider.notifier).state =
          merchant.copyWith(isOpened: !active);
      return;
    }
  }

  void showMessage(String message) => showToast(message, context);

  @override
  Widget build(BuildContext context) {
    Merchant merchant = ref.watch(userProvider) as Merchant;
    List<Order> orders =
        loading ? dummyOrders : ref.watch(merchantOrdersProvider);
    bool canShowData = loading || orders.isNotEmpty;

    return SingleChildScrollView(
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
                      onChanged: (val) {
                        modifyStore(!merchant.isOpened);
                        ref.watch(userProvider.notifier).state =
                            merchant.copyWith(
                          isOpened: !merchant.isOpened,
                        );
                      },
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
              if (!loading && orders.length > 2)
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
          if (canShowData)
            SizedBox(
              height: 180.h,
              child: Skeletonizer(
                enabled: loading,
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
            ),
          if (!canShowData)
            Center(
              child: Column(
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
        ],
      ),
    );
  }
}
