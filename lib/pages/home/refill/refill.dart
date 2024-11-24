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
  bool loadingExpress = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getExpress();
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

  void showMessage(String message) => showToast(message, context);

  @override
  Widget build(BuildContext context) {
    if (loadingExpress) {
      return const Center(
        child: loader,
      );
    }

    List<UserOrder> orders = ref.watch(initialExpressOrdersProvider);
    return orders.isNotEmpty && orders.first.status != "DELIVERED"
        ? _HasOrder(order: orders.first)
        : const _NoOrder();
  }
}

class _HasOrder extends ConsumerStatefulWidget {
  final UserOrder order;

  const _HasOrder({
    super.key,
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
          SizedBox(height: 20.h),
          SizedBox(
            height: 580.h,
            width: 375.w,
            child: _CustomOrderStepper(
              data: widget.order.states,
              paymentUrl: widget.order.paymentUrl,
              canPay: widget.order.status == "MATCHED",
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

class _CustomOrderStepper extends StatefulWidget {
  final String paymentUrl;
  final bool canPay;
  final List<OrderStates> data;

  const _CustomOrderStepper({
    super.key,
    required this.canPay,
    required this.paymentUrl,
    required this.data,
  });

  @override
  State<_CustomOrderStepper> createState() => _CustomOrderStepperState();
}

class _CustomOrderStepperState extends State<_CustomOrderStepper> {
  late int total;

  late Widget completedStepIcon,
      nextStepToBeCompletedIcon,
      notCompletedStepIcon;

  @override
  void initState() {
    super.initState();
    total = OrderState.values.length - 1;
    completedStepIcon = Center(
      child: Icon(
        Icons.done,
        size: 26.r,
        color: Colors.white,
      ),
    );

    nextStepToBeCompletedIcon = Center(
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: Colors.white,
        child: Center(
          child: CircleAvatar(
            radius: 5.r,
            backgroundColor: primary,
          ),
        ),
      ),
    );

    notCompletedStepIcon = Center(
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: Colors.white,
      ),
    );
  }

  String getOrderTitle(int index) {
    switch (index) {
      case 0:
        return "Pending";
      case 1:
        return "Matched";
      case 2:
        return "Paid";
      case 3:
        return "Picked Up";
      case 4:
        return "Refilled";
      case 5:
        return "Dispatched";
      case 6:
        return "Delivered";
      default:
        return "";
    }
  }

  String getOrderSubtitle(int index) {
    switch (index) {
      case 0:
        return "Your request is pending";
      case 1:
        return "Your request has been matched!";
      case 2:
        return "Your payment has been confirmed!";
      case 3:
        return "Your gas cylinder has been picked up!";
      case 4:
        return "Your gas cylinder has been refilled";
      case 5:
        return "Your gas cylinder is already on its way back";
      case 6:
        return "Your gas cylinder has been delivered";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: total,
      itemBuilder: (_, index) {
        OrderState state = OrderState.values[index];
        bool hasStepBeingCompleted = index < widget.data.length;
        bool isNextToBeCompleted = index == widget.data.length;
        bool isLastStep = index == total - 1;
        DateTime? stepTimestamp;
        if (index < widget.data.length) {
          stepTimestamp = DateTime.parse(widget.data[index].timestamp);
        }

        return SizedBox(
          width: 375.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: primary,
                    child: hasStepBeingCompleted
                        ? completedStepIcon
                        : isNextToBeCompleted
                            ? nextStepToBeCompletedIcon
                            : notCompletedStepIcon,
                  ),
                  if (!isLastStep)
                    Container(
                      width: 2.w,
                      height: 60.r,
                      color: primary50,
                    )
                ],
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getOrderTitle(index),
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    getOrderSubtitle(index),
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.canPay && index == 2)
                    ElevatedButton(
                      onPressed: () => launchPayStackUrl(widget.paymentUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.5.r),
                        ),
                        elevation: 1.0,
                        fixedSize: Size(150.w, 40.h),
                      ),
                      child: Text(
                        "Make Payment",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (stepTimestamp != null)
                    Text(
                      formatDateRawWithTime(stepTimestamp),
                      style: context.textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
