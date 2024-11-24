import 'package:eexily/api/individual.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class IndividualOrderHistory extends ConsumerStatefulWidget {
  const IndividualOrderHistory({
    super.key,
  });

  @override
  ConsumerState<IndividualOrderHistory> createState() =>
      _IndividualOrderHistoryState();
}

class _IndividualOrderHistoryState
    extends ConsumerState<IndividualOrderHistory> {
  bool loadingStandard = false, loadingExpress = false;

  @override
  void initState() {
    super.initState();

    List<UserOrder> expressOrders = ref.read(initialExpressOrdersProvider);
    List<UserOrder> scheduledOrders = ref.read(initialStandardOrdersProvider);

    if (expressOrders.isEmpty) {
      loadingExpress = true;
    }

    if (scheduledOrders.isEmpty) {
      loadingStandard = true;
    }

    Future.delayed(Duration.zero, () {
      if (loadingExpress) {
        getExpress();
      }
      if (loadingStandard) {
        getStandard();
      }
    });
  }

  Future<void> getExpress() async {
    var response = await getUserExpressOrders();
    setState(() => loadingExpress = false);
    if (!response.status) {
      showMessage(response.message);
      return;
    }

    ref.watch(initialExpressOrdersProvider.notifier).state = response.payload;
  }

  Future<void> getStandard() async {
    var response = await getUserStandardOrders();
    setState(() => loadingStandard = false);
    if (!response.status) {
      showMessage(response.message);
      return;
    }

    ref.watch(initialStandardOrdersProvider.notifier).state = response.payload;
  }

  void showMessage(String message) => showToast(message, context);

  @override
  Widget build(BuildContext context) {
    List<UserOrder> expressOrders = ref.watch(initialExpressOrdersProvider);
    List<UserOrder> scheduledOrders = ref.watch(initialStandardOrdersProvider);

    List<UserOrder> expressData =
        loadingExpress ? dummyUserOrders : expressOrders;
    List<UserOrder> scheduledData =
        loadingStandard ? dummyUserOrders : scheduledOrders;
    bool canShowExpressData = loadingExpress || expressOrders.isNotEmpty;
    bool canShowStandardData = loadingStandard || scheduledOrders.isNotEmpty;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            child: Column(
              children: [
                TabBar(
                  dividerColor: Colors.transparent,
                  labelStyle: context.textTheme.titleMedium,
                  tabs: const [
                    Tab(text: "Standard"),
                    Tab(text: "Express"),
                  ],
                ),
                SizedBox(height: 5.h),
                Expanded(
                  child: TabBarView(
                    children: [
                      if (canShowStandardData)
                        Skeletonizer(
                          enabled: loadingStandard,
                          child: RefreshIndicator(
                            onRefresh: () async {},
                            child: ListView.separated(
                              itemBuilder: (_, index) {
                                if (index == scheduledData.length) {
                                  return SizedBox(height: 20.h);
                                }

                                UserOrder order = scheduledData[index];

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Order #${index + 1}",
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Delivered to: ",
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: order.address,
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
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
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: "${order.quantity}kg",
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
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
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text:
                                                  "₦${formatAmount(order.price.toStringAsFixed(0))}",
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
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
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: formatDateRawWithTime(
                                                  DateTime.parse(
                                                      order.scheduledTime)),
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 10.h),
                              itemCount: scheduledData.length + 1,
                            ),
                          ),
                        ),
                      if (!canShowStandardData)
                        Center(
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
                                "Oops :(",
                                style: context.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                "Seems like you have not made any standard orders.",
                                style: context.textTheme.bodyMedium!.copyWith(
                                  fontFamily: "WorkSans",
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () {
                                  setState(() => loadingStandard = true);
                                  getStandard();
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
                            ],
                          ),
                        ),
                      if (canShowExpressData)
                        Skeletonizer(
                          enabled: loadingExpress,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              setState(() => loadingExpress = true);
                              getExpress();
                            },
                            child: ListView.separated(
                              itemBuilder: (_, index) {
                                if (index == expressData.length) {
                                  return SizedBox(height: 20.h);
                                }

                                UserOrder order = expressData[index];

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "G-Code: ${order.code}",
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Address: ",
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: order.address,
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Amount of gas ordered: ",
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: "${order.quantity}kg",
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Amount paid: ",
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text:
                                                  "₦${formatAmount(order.price.toStringAsFixed(0))}",
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Date Ordered: ",
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: formatDateRawWithTime(
                                                DateTime.parse(
                                                    order.pickedUpTime),
                                              ),
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Seller Type: ",
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: order.sellerType
                                                  .toLowerCase()
                                                  .replaceAll("_", "")
                                                  .capitalize,
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Status: ",
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: order.status
                                                  .toLowerCase()
                                                  .replaceAll("_", " ")
                                                  .capitalize,
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 10.h),
                              itemCount: expressData.length + 1,
                            ),
                          ),
                        ),
                      if (!canShowExpressData)
                        Center(
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
                                "Oops :(",
                                style: context.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                "Seems like you have not made any express orders.",
                                style: context.textTheme.bodyMedium!.copyWith(
                                  fontFamily: "WorkSans",
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () {
                                  setState(() => loadingExpress = true);
                                  getExpress();
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
                            ],
                          ),
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
