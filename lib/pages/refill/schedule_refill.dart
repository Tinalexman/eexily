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
import 'package:iconsax_plus/iconsax_plus.dart';

class ScheduleRefillPage extends ConsumerStatefulWidget {
  final String scheduledTime;

  const ScheduleRefillPage({
    super.key,
    required this.scheduledTime,
  });

  @override
  ConsumerState<ScheduleRefillPage> createState() => _ScheduleRefillPageState();
}

class _ScheduleRefillPageState extends ConsumerState<ScheduleRefillPage> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  late DateTime deliveryDate;
  late String nextDeliveryTime;

  bool loading = true;
  bool shouldMakeAddressEditable = false;

  int currentPriceOfGas = 1, deliveryFee = 0;
  int totalAmountToPay = 0, priceMarkup = -1;
  int fakePriceToPayForGas = 0, fakeDiscount = 0, actualGasAmount = 0;

  @override
  void initState() {
    super.initState();
    setCurrentUserAddress();
    determineAppropriateDeliveryDateAndTime();
    Future.delayed(Duration.zero, getCurrentPrices);
  }

  void setCurrentUserAddress() {
    String address = ref.read(userProvider.select((u) => (u as User).address));
    addressController.text = address;
  }

  void determineAppropriateDeliveryDateAndTime() {
    deliveryDate = DateTime.now();
    nextDeliveryTime = widget.scheduledTime;
    if (deliveryDate.hour > 17) {
      deliveryDate = DateUtilities.getDaysAhead(1);
    } else if (widget.scheduledTime == "12PM" && deliveryDate.hour > 12) {
      nextDeliveryTime = "5PM";
    }
  }

  Future<void> getCurrentPrices() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      currentPriceOfGas = 1100;
      deliveryFee = 200;
      priceMarkup = 100;
      loading = false;
    });
  }

  Future<void> createOrder() async {
    String id = ref.watch(userProvider.select((u) => u.id));
    String address = addressController.text.trim();
    int quantity = int.parse(quantityController.text.trim());

    Map<String, dynamic> data = {
      "pickedUpTime": widget.scheduledTime,
      "quantity": quantity,
      "address": address,
      "price": (currentPriceOfGas * quantity),
      "deliveryFee": (deliveryFee * 0.4).toInt(),
      "paymentMethod": "Paystack",
      "user": id,
    };

    var response = await createScheduledOrder(data);
    setState(() => loading = false);
    showMessage(response.message);
    if(!response.status) return;

    showSuccessModal(response.payload!);
  }

  void showMessage(String message) => showToast(message, context);

  @override
  void dispose() {
    addressController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void calculateNewTotalAmount(String value) {
    int? targetQuantity = int.tryParse(value);
    if (targetQuantity != null) {
      fakeDiscount = priceMarkup * targetQuantity;
      actualGasAmount = currentPriceOfGas * targetQuantity;
      fakePriceToPayForGas = (currentPriceOfGas + priceMarkup) * targetQuantity;
      totalAmountToPay =
          (currentPriceOfGas * targetQuantity) + (deliveryFee * 0.4).toInt();
    } else {
      fakeDiscount = 0;
      actualGasAmount = 0;
      fakePriceToPayForGas = 0;
      totalAmountToPay = 0;
    }
    setState(() {});
  }

  void showSuccessModal(String code) {
    ref.watch(currentUserOrderProvider.notifier).state = code;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessModal(
        text: "You have successfully scheduled for a refill",
        onDismiss: () {
          Navigator.of(context).pop();
          context.router.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Schedule a refill",
          style: context.textTheme.titleLarge!.copyWith(
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
                Text(
                  "Price of gas per kg:",
                  style: context.textTheme.bodyLarge,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "₦${formatAmount("${currentPriceOfGas - 1}")} ",
                        style: context.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            "₦${formatAmount("${currentPriceOfGas + priceMarkup}")}",
                        style: context.textTheme.bodyMedium!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: neutral2,
                          fontWeight: FontWeight.w500,
                          color: neutral2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                Text(
                  "Quantity of gas (kg)?",
                  style: context.textTheme.bodyMedium,
                ),
                SizedBox(height: 4.h),
                SpecialForm(
                  controller: quantityController,
                  width: 375.w,
                  type: TextInputType.number,
                  hint: "e.g 10",
                  readOnly: loading,
                  onChange: calculateNewTotalAmount,
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Address",
                      style: context.textTheme.bodyMedium,
                    ),
                    if (!shouldMakeAddressEditable)
                      GestureDetector(
                        onTap: () =>
                            setState(() => shouldMakeAddressEditable = true),
                        child: Text(
                          "Change",
                          style: context.textTheme.bodySmall!.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                SpecialForm(
                  controller: addressController,
                  width: 375.w,
                  maxLines: 4,
                  readOnly: !shouldMakeAddressEditable,
                  fillColor: shouldMakeAddressEditable ? null : neutral,
                  hint: "e.g House 12, Camp Junction, Abeokuta",
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
                      child: const Icon(IconsaxPlusBroken.wallet_2),
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
                      child: const Icon(IconsaxPlusBroken.truck_fast),
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
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            CircleAvatar(
                              backgroundColor: primary,
                              radius: 2.5.r,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              nextDeliveryTime,
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 60.h),
                Text(
                  "Analysis",
                  style: context.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Price",
                      style: context.textTheme.bodyLarge,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          if (totalAmountToPay == 0)
                            TextSpan(
                              text: "₦0",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (totalAmountToPay != 0)
                            TextSpan(
                              text: "₦${formatAmount("$actualGasAmount")} ",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (totalAmountToPay != 0)
                            TextSpan(
                              text: "₦${formatAmount("$fakePriceToPayForGas")}",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: neutral2,
                                color: neutral2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Delivery Fee",
                      style: context.textTheme.bodyLarge,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          if (totalAmountToPay == 0)
                            TextSpan(
                              text: "₦0",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (totalAmountToPay != 0)
                            TextSpan(
                              text:
                                  "₦${formatAmount((deliveryFee * 0.4).toStringAsFixed(0))} ",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (totalAmountToPay != 0)
                            TextSpan(
                              text: "₦${formatAmount("$deliveryFee")}",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: neutral2,
                                color: neutral2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "We saved you",
                      style: context.textTheme.bodyLarge,
                    ),
                    if (totalAmountToPay == 0)
                      Text(
                        "₦0",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                    if (totalAmountToPay != 0)
                      Text(
                        "₦${formatAmount(((fakePriceToPayForGas - actualGasAmount) + (deliveryFee * 0.6)).toInt().toStringAsFixed(0))}",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Amount",
                      style: context.textTheme.bodyLarge,
                    ),
                    Text(
                      "₦${formatAmount("${totalAmountToPay == 0 ? 0 : totalAmountToPay}")}",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    elevation: 1.0,
                    fixedSize: Size(375.w, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5.r),
                    ),
                  ),
                  onPressed: () {
                    String quantity = quantityController.text.trim();
                    if(quantity.isEmpty) {
                      showToast("Enter your desired gas quantity", context);
                      return;
                    }

                    setState(() => loading = true);
                    createOrder();
                  },
                  child: loading
                      ? whiteLoader
                      : Text(
                          "Confirm",
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
