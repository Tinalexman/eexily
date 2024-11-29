import 'package:eexily/api/refill.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/driver.dart' as d;
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart' as wd;
import 'package:flutter/foundation.dart';
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
  bool hasFilter = false;

  final List<Order> filteredOrders = [];

  String id = "";
  d.Type driverType = d.Type.nil;

  final List<String> filterOptions = [
    "All",
    "Paid",
    "Refilled",
    "Delivered",
  ];

  int currentFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    d.Driver driver = ref.read(userProvider) as d.Driver;
    id = driver.riderId;
    driverType = driver.type;
    loading = true;
    Future.delayed(Duration.zero, getOrders);
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

  Future<void> onFilterChange(int newFilterIndex) async {
    filteredOrders.clear();
    currentFilterIndex = newFilterIndex;

    if (newFilterIndex == 0) {
      hasFilter = false;
      setState(() {});
      return;
    }

    List<Order> orders = ref.watch(driverOrdersProvider);

    List<Order> response = await compute(
      filterDriverOrders,
      FilterOption(
        orders: orders,
        filterIndex: newFilterIndex,
      ),
    );
    filteredOrders.addAll(response);
    hasFilter = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Order> driverOrders = hasFilter
        ? filteredOrders
        : loading
            ? dummyOrders
            : ref.watch(driverOrdersProvider);
    bool canShowData = hasFilter || loading || driverOrders.isNotEmpty;

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
          Column(
            children: [
              SizedBox(
                height: 50.h,
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    bool selected = currentFilterIndex == index;
                    return GestureDetector(
                      onTap: () => onFilterChange(index),
                      child: Chip(
                        label: Text(
                          filterOptions[index],
                          style: context.textTheme.bodySmall!.copyWith(
                            fontWeight:
                                selected ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                        backgroundColor:
                            selected ? secondary : primary50.withOpacity(0.2),
                        elevation: selected ? 1.0 : 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.5.r),
                        ),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemCount: filterOptions.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        if (canShowData)
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() => loading = true);
                getOrders();
              },
              child: Skeletonizer(
                enabled: loading,
                child: ListView.separated(
                  itemBuilder: (_, index) => wd.NonUserOrderContainer(
                    order: driverOrders[index],
                    destination: Pages.viewDriverOrder,
                    key: ValueKey<String>(driverOrders[index].id),
                  ),
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  padding: const EdgeInsets.all(1),
                  itemCount: driverOrders.length,
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
