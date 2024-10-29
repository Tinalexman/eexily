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

class RefillPage extends ConsumerStatefulWidget {
  const RefillPage({super.key});

  @override
  ConsumerState<RefillPage> createState() => _RefillPageState();
}

class _RefillPageState extends ConsumerState<RefillPage> {
  @override
  Widget build(BuildContext context) {
    String? currentOrderCode = ref.watch(currentUserOrderProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Refill Gas",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: GestureDetector(
              onTap: () => context.router.pushNamed(Pages.individualOrderHistory),
              child: Text(
                "History",
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: primary,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: currentOrderCode != null
              ? _HasOrder(orderCode: currentOrderCode)
              : const _NoOrder(),
        ),
      ),
    );
  }
}

class _HasOrder extends ConsumerStatefulWidget {
  final String orderCode;

  const _HasOrder({
    super.key,
    required this.orderCode,
  });

  @override
  ConsumerState<_HasOrder> createState() => _HasOrderState();
}

class _HasOrderState extends ConsumerState<_HasOrder> {

  final List<UserOrder> orders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getOrder);
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> getOrder() async {
    var response = await getUserOrders();
    showMessage(response.message);
    setState(() {
      loading = false;
      orders.clear();
      orders.addAll(response.payload);
    });
  }

  Color getOrderColor(String orderState) {
    switch(orderState) {
      case "PENDING": return secondary;
      case "MATCHED": return secondary3;
      case "REFILL": return secondary2;
      case "DISPATCHED": return Colors.red;
      case "DELIVERED": return primary;
      default: return monokai;
    }
  }


  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userProvider) as User;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: monokai),
                ),
                child: Icon(
                  Icons.done_rounded,
                  size: 28.r,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "Thank you ${user.firstName}!",
                style: context.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          if(loading)
            const Center(
              child: loader,
            ),
          if(!loading && orders.isEmpty)
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80.h),
                  Image.asset(
                    "assets/images/error.png",
                    width: 200.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Orders not found",
                    style: context.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      setState(() => loading = true);
                      getOrder();
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
          if(!loading && orders.isNotEmpty)
            Container(
              width: 390.w,
              decoration: BoxDecoration(
                color: primary50.withOpacity(0.3),
                borderRadius: BorderRadius.circular(7.5.r),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 10.h,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Order ID:",
                        style: context.textTheme.bodyLarge,
                      ),
                      Text(
                        orders[0].code,
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: monokai,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Amount Paid:",
                        style: context.textTheme.bodyLarge,
                      ),
                      Text(
                        "₦${formatAmount(orders[0].price.toStringAsFixed(0))}",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: monokai,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Gas Quantity:",
                        style: context.textTheme.bodyLarge,
                      ),
                      Text(
                        "${orders[0].quantity}kg",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: monokai,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Status:",
                        style: context.textTheme.bodyLarge,
                      ),
                      Text(
                        orders[0].orderState,
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: getOrderColor(orders[0].orderState),
                        ),
                      ),
                    ],
                  ),
                ],
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
              Tab(text: "Standard Delivery"),
              Tab(text: "Express Delivery"),
            ],
          ),
          SizedBox(height: 10.h),
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
            "Plan ahead and save cash with our standard delivery! Choose a convenient "
            "time slot for your gas refill. We do deliveries every day at 12pm and 5pm.",
            style: context.textTheme.bodyMedium,
          ),
          SizedBox(height: 10.h),
          Text(
            "Pick a slot that fits your schedule and enjoy lower delivery fees. It’s easy and budget-friendly!",
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
          SizedBox(height: 110.h),
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
            "Need gas urgently? No problem! With ‘Express Delivery’, get your gas delivered as "
            "soon as possible. Just let us know where you are, and we’ll take care of the rest. "
            "It’s quick and hassle-free!",
            style: context.textTheme.bodyMedium,
            // textAlign: TextAlign.center,
          ),
          SizedBox(height: 200.h),
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
