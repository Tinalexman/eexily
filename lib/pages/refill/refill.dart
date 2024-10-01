import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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
              onTap: () {},
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

class _HasOrder extends ConsumerWidget {
  final UserOrder order;

  const _HasOrder({
    super.key,
    required this.order,
  });

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
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.watch(userProvider) as User;

    return Column(
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
                  "G-Code: ${order.code}",
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
          height: 400.h,
          child: Stepper(
            elevation: 1.0,
            physics: const BouncingScrollPhysics(),
            currentStep: order.states.length - 1,
            type: StepperType.vertical,

            steps: List.generate(
              OrderState.values.length,
              (index) {
                bool isActive = index < order.states.length;
                OrderDeliveryData? data;

                if (index < order.states.length) {
                  data = order.states[index];
                }

                return Step(
                  title: Text(
                    getOrderTitle(index),
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: const SizedBox(),
                  isActive: isActive,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getOrderSubtitle(index),
                        style: context.textTheme.bodyMedium,
                      ),
                      if (data != null)
                        Text(
                          formatDateRawWithTime(data.timestamp),
                          style: context.textTheme.bodySmall,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
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
  String? currentSlot;

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
            "Plan ahead and save with our batch delivery! Choose a convenient "
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
          ComboBox(
            onChanged: (val) => setState(() => currentSlot = val),
            value: currentSlot,
            dropdownItems: const ['12pm', '5pm'],
            hint: "Select",
            dropdownWidth: 100.w,
            buttonWidth: 100.w,
            icon: const Icon(
              IconsaxPlusLinear.arrow_down,
              color: monokai,
            ),
          ),
          SizedBox(height: 110.h),
          if (currentSlot != null)
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
