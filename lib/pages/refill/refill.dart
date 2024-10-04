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
    UserOrder? currentOrder = ref.watch(currentUserOrderProvider);

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
          child: currentOrder != null
              ? _HasOrder(order: currentOrder)
              : const _NoOrder(),
        ),
      ),
    );
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
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "G-Code: ${widget.order.code}",
                    style: context.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Thank you ${user.firstName}!",
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 350.h,
            width: 375.w,
            child: _CustomOrderStepper(data: widget.order.states),
          ),
          SizedBox(height: 40.h),
          Text(
            "Feedback and comments",
            style: context.textTheme.bodyLarge,
          ),
          SizedBox(height: 4.h),
          SpecialForm(
            controller: controller,
            width: 375.w,
            maxLines: 4,
            hint: "e.g I had a very good experience",
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              minimumSize: Size(375.w, 50.h),
              fixedSize: Size(375.w, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5.r),
              ),
            ),
            child: Text(
              "Submit",
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomOrderStepper extends StatefulWidget {
  final List<OrderDeliveryData> data;

  const _CustomOrderStepper({
    super.key,
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
    total = OrderState.values.length;
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
        return "Gas cylinder pick up";
      case 1:
        return "Refilled";
      case 2:
        return "Dispatched";
      case 3:
        return "Delivered";
      default:
        return "";
    }
  }

  String getOrderSubtitle(int index) {
    switch (index) {
      case 0:
        return "Your gas cylinder has been picked up";
      case 1:
        return "Your gas cylinder has been refilled";
      case 2:
        return "Your gas cylinder is on its way back";
      case 3:
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
        bool hasStepBeingCompleted = index < widget.data.length;
        bool isNextToBeCompleted = index == widget.data.length;
        bool isLastStep = index == total - 1;
        DateTime? stepTimestamp;
        if (index < widget.data.length) {
          stepTimestamp = widget.data[index].timestamp;
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
              Tab(text: "Schedule a refill"),
              Tab(text: "Refill now"),
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
            "Plan ahead and save cash with our batch delivery! Choose a convenient "
            "time slot for your gas refill. We do deliveries every day at 12noon and 5pm.",
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
                    groupValue: "12pm",
                    onChanged: (val) {
                      setState(() => currentSlot = "12pm");
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
                    groupValue: "5pm",
                    onChanged: (val) {
                      setState(() => currentSlot = "5pm");
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
            "Need gas urgently? No problem! With ‘Refill Now,’ get your gas delivered as "
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
