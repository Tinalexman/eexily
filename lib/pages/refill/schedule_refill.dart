import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleRefillPage extends ConsumerStatefulWidget {
  const ScheduleRefillPage({super.key});

  @override
  ConsumerState<ScheduleRefillPage> createState() => _ScheduleRefillPageState();
}

class _ScheduleRefillPageState extends ConsumerState<ScheduleRefillPage> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  late DateTime deliveryDate;

  @override
  void initState() {
    super.initState();
    deliveryDate = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 172800000);
  }

  @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void showSuccessModal() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: Container(
          width: 220.w,
          height: 200.h,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/success.png",
                fit: BoxFit.cover,
              ),
              Text(
                "You have successfully scheduled a refill",
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.router.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: Size(60.w, 30.h),
                  fixedSize: Size(60.w, 30.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.5.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                ),
                child: Text(
                  "Close",
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String address = ref.watch(userProvider.select((u) => u.address));

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,

        title: Text(
          "Schedule a refill",
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                Text(
                  "Quantity of required gas (kg)?",
                  style: context.textTheme.bodyMedium,
                ),
                SizedBox(height: 4.h),
                SpecialForm(
                  controller: quantityController,
                  width: 375.w,
                  height: 50.h,
                  type: TextInputType.number,
                  hint: "e.g 10",
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Address",
                        style: context.textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: " change",
                        style: context.textTheme.bodySmall!.copyWith(
                          color: primary,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 375.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      7.5.r,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: 0,
                        onChanged: (val) {},
                        activeColor: neutral3,
                      ),
                      Text(
                        address,
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: neutral3,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Price (NGN)",
                  style: context.textTheme.bodyMedium,
                ),
                SizedBox(height: 4.h),
                SpecialForm(
                  controller: priceController,
                  width: 375.w,
                  height: 50.h,
                  type: TextInputType.number,
                  hint: "0.00",
                  textColor: primary,
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: const BoxDecoration(
                        color: gasUsageContainerStart,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/wallet.png",
                        width: 50.w,
                        height: 50.w,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Pay on delivery",
                      style: context.textTheme.bodyMedium,
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: const BoxDecoration(
                        color: gasUsageContainerStart,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/truck.png",
                        width: 50.w,
                        height: 50.w,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Next delivery date:",
                          style: context.textTheme.bodyMedium,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${getWeekDay(deliveryDate.weekday)} ${formatDateRaw(deliveryDate)}",
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(width: 5.w),
                            CircleAvatar(
                              backgroundColor: primary,
                              radius: 3.r,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "9am",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: primary,
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 150.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    elevation: 1.0,
                    fixedSize: Size(375.w, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5.r),
                    ),
                  ),
                  onPressed: showSuccessModal,
                  child: Text(
                    "Confirm",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
