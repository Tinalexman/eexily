import 'package:eexily/api/attendant.dart';
import 'package:eexily/api/refill.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
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
  bool loading = true;
  String id = "";

  bool hasFilter = false;
  final List<Order> filteredOrders = [];

  final List<String> filterOptions = [
    "All",
    "Paid",
    "Refilled",
  ];

  int currentFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    Attendant attendant = ref.read(userProvider) as Attendant;
    id = attendant.id;
    Future.delayed(Duration.zero, getOrders);
  }

  Future<void> getOrders() async {
    var response = await getAttendantOrders(id);
    if (!context.mounted) return;
    setState(() => loading = false);

    if (!response.status) {
      showMessage(response.message);
      return;
    }

    ref.watch(attendantOrdersProvider.notifier).state = response.payload;
  }

  Future<void> modifyStation(bool active) async {
    Attendant attendant = ref.watch(userProvider) as Attendant;
    var response =
        await updateAttendantUser({"isOpened": active}, attendant.id);
    setState(() => loading = false);

    if (!response.status) {
      showMessage(response.message);
      ref.watch(userProvider.notifier).state =
          attendant.copyWith(isOpened: !active);
      return;
    }
  }

  Future<void> onFilterChange(int newFilterIndex) async {
    filteredOrders.clear();
    currentFilterIndex = newFilterIndex;

    if (newFilterIndex == 0) {
      hasFilter = false;
      setState(() {});
      return;
    }

    List<Order> orders = ref.watch(attendantOrdersProvider);

    List<Order> response = await compute(
      filterOtherOrders,
      FilterOption(
        orders: orders,
        filterIndex: newFilterIndex,
      ),
    );
    filteredOrders.addAll(response);
    hasFilter = true;
    setState(() {});
  }

  void showMessage(String message) => showToast(message, context);

  @override
  Widget build(BuildContext context) {
    Attendant attendant = ref.watch(userProvider) as Attendant;
    List<Order> attendantOrders = hasFilter
        ? filteredOrders
        : loading
            ? dummyOrders
            : ref.watch(attendantOrdersProvider);
    bool canShowData = hasFilter || loading || attendantOrders.isNotEmpty;

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
                  attendant.gasStationName,
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
                    attendant.isOpened ? "Opened" : "Closed",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: monokai,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: attendant.isOpened,
                      onChanged: (val) {
                        modifyStation(!attendant.isOpened);
                        ref.watch(userProvider.notifier).state =
                            attendant.copyWith(
                          isOpened: !attendant.isOpened,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            "Orders of the day",
            style: context.textTheme.titleMedium!.copyWith(
              color: monokai,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          if (!canShowData)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120.h),
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
            SizedBox(
              height: 600.h,
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() => loading = true);
                  getOrders();
                },
                child: Skeletonizer(
                  enabled: loading,
                  child: ListView.separated(
                    itemBuilder: (_, index) => NonUserOrderContainer(
                      order: attendantOrders[index],
                      destination: Pages.viewAttendantOrder,
                    ),
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    padding: const EdgeInsets.all(1),
                    itemCount: attendantOrders.length,
                    physics: const BouncingScrollPhysics(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
