import 'package:eexily/api/individual.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Refill extends ConsumerStatefulWidget {
  const Refill({super.key});

  @override
  ConsumerState<Refill> createState() => _RefillState();
}

class _RefillState extends ConsumerState<Refill> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getExpress();
    });
  }

  Future<void> getExpress() async {
    var response = await getUserExpressOrders();
    ref.watch(loadingInitialExpressOrdersProvider.notifier).state = false;
    if (!response.status) {
      showMessage(response.message);
      return;
    }

    ref.watch(initialExpressOrdersProvider.notifier).state = response.payload;
  }

  void showMessage(String message) => showToast(message, context);

  @override
  Widget build(BuildContext context) {
    bool loadingExpress = ref.watch(loadingInitialExpressOrdersProvider);

    if (loadingExpress) {
      return const Center(
        child: loader,
      );
    }

    List<Order> orders = ref.watch(initialExpressOrdersProvider);
    return orders.isNotEmpty &&
            orders.first.status != "DELIVERED" &&
            orders.first.status != "CANCELED"
        ? _HasOrder(
            order: orders.first,
            getExpress: getExpress,
          )
        : const _NoOrder();
  }
}

class _HasOrder extends ConsumerStatefulWidget {
  final Order order;
  final VoidCallback getExpress;

  const _HasOrder({
    super.key,
    required this.getExpress,
    required this.order,
  });

  @override
  ConsumerState<_HasOrder> createState() => _HasOrderState();
}

class _HasOrderState extends ConsumerState<_HasOrder> {
  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userProvider) as User;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Thank you ${user.firstName}! 🥳🥳🥳",
            style: context.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "G-Code: ${widget.order.code}",
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 580.h,
            width: 375.w,
            child: RefreshIndicator(
              onRefresh: () async {
                ref.watch(loadingInitialExpressOrdersProvider.notifier).state =
                    true;
                widget.getExpress();
              },
              child: CustomOrderStepper(
                order: widget.order,
                onUpdateState: (order) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoOrder extends StatelessWidget {
  const _NoOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const Expanded(
            child: TabBarView(
              children: [
                _ScheduleRefill(),
                _RefillNow(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ScheduleRefill extends StatefulWidget {
  const _ScheduleRefill({super.key});

  @override
  State<_ScheduleRefill> createState() => _ScheduleRefillState();
}

class _ScheduleRefillState extends State<_ScheduleRefill> {
  String currentSlot = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              "assets/images/schedule refill.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 50.h),
          Text(
            "Plan ahead and save with our standard delivery, and we’ll refill your gas at 12pm or 5pm daily!",
            style: context.textTheme.bodyMedium,
          ),
          SizedBox(height: 20.h),
          Text(
            "Slot",
            style: context.textTheme.bodyMedium,
          ),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                    value: currentSlot,
                    groupValue: "12PM",
                    onChanged: (val) {
                      setState(() => currentSlot = "12PM");
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    "12pm",
                    style: context.textTheme.bodyMedium,
                  )
                ],
              ),
              SizedBox(width: 20.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                    value: currentSlot,
                    groupValue: "5PM",
                    onChanged: (val) {
                      setState(() => currentSlot = "5PM");
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    "5pm",
                    style: context.textTheme.bodyMedium,
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 150.h),
          if (currentSlot.isNotEmpty)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5.r),
                ),
                backgroundColor: primary,
                minimumSize: Size(375.w, 50.h),
                fixedSize: Size(375.w, 50.h),
              ),
              onPressed: () => context.router.pushNamed(
                Pages.scheduleRefill,
                extra: currentSlot,
              ),
              child: Text(
                "Continue",
                style: context.textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RefillNow extends StatelessWidget {
  const _RefillNow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/refill now.png",
            fit: BoxFit.cover,
          ),
          SizedBox(height: 50.h),
          Text(
            "Running low on gas? We'll bring it to you fast and hassle-free!",
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 197.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5.r),
              ),
              backgroundColor: primary,
              minimumSize: Size(375.w, 50.h),
              fixedSize: Size(375.w, 50.h),
            ),
            onPressed: () => context.router.pushNamed(Pages.refillNow),
            child: Text(
              "Continue",
              style: context.textTheme.titleMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
