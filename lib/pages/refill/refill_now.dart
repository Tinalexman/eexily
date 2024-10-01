import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RefillNowPage extends ConsumerStatefulWidget {
  const RefillNowPage({super.key});

  @override
  ConsumerState<RefillNowPage> createState() => _RefillNowPageState();
}

class _RefillNowPageState extends ConsumerState<RefillNowPage> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool loading = true;
  bool shouldMakeAddressEditable = false;

  int currentPriceOfGas = 1, deliveryFee = 0, actualGasAmount = 0;
  int totalAmountToPay = 0, priceMarkup = -1, nightOrderFee = 100;
  int fakePriceToPayForGas = 0, fakeDiscount = 0;

  @override
  void initState() {
    super.initState();
    setCurrentUserAddress();
    Future.delayed(Duration.zero, getCurrentPrices);
  }

  void setCurrentUserAddress() {
    String address = ref.read(userProvider.select((u) => (u as User).address));
    addressController.text = address;
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

  @override
  void dispose() {
    addressController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void calculateNewTotalAmount(String value) {
    int? targetQuantity = int.tryParse(value);
    if (targetQuantity != null) {
      bool isLate = DateTime.now().hour >= 21;
      fakeDiscount = priceMarkup * targetQuantity;
      fakePriceToPayForGas = (currentPriceOfGas + priceMarkup) * targetQuantity;
      actualGasAmount = (currentPriceOfGas * targetQuantity);
      totalAmountToPay = actualGasAmount + deliveryFee;
      totalAmountToPay += isLate ? nightOrderFee : 0;
    } else {
      fakeDiscount = 0;
      actualGasAmount = 0;
      fakePriceToPayForGas = 0;
      totalAmountToPay = 0;
    }
    setState(() {});
  }

  void showSuccessModal() {
    String code = randomGCode;
    String name = (ref.watch(userProvider) as User).fullName;

    ref.watch(currentUserOrderProvider.notifier).state = UserOrder(
      code: code,
      username: name,
      states: [
        OrderDeliveryData(
          state: OrderState.pickedUp,
          timestamp: DateUtilities.getMinutesBefore(5),
        ),
        OrderDeliveryData(
          state: OrderState.refilled,
          timestamp: DateUtilities.getMinutesBefore(2),
        ),
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessModal(
        text: "You have successfully booked a refill",
        onDismiss: () {
          Navigator.of(context).pop();
          context.router.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLate = DateTime.now().hour >= 21;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Refill Now",
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
                SizedBox(height: 160.h),
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
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(
                          text: "₦${formatAmount("$actualGasAmount")} ",
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: "₦${formatAmount("$fakePriceToPayForGas")}",
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: neutral2,
                            color: neutral2,
                          ),
                        ),
                      ]
                    ),),

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
                    Text(
                      "₦${formatAmount("${totalAmountToPay == 0 ? 0 : deliveryFee}")}",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (isLate)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Night Order Fee",
                        style: context.textTheme.bodyLarge,
                      ),
                      Text(
                        "₦${formatAmount("$nightOrderFee")}",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
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
                    Text(
                      "₦${formatAmount("$fakeDiscount")}",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: totalAmountToPay == 0
                        ? primary.withOpacity(0.6)
                        : primary,
                    elevation: 1.0,
                    fixedSize: Size(375.w, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5.r),
                    ),
                  ),
                  onPressed: showSuccessModal,
                  child: loading
                      ? whiteLoader
                      : Text(
                          "Pay ₦${formatAmount("$totalAmountToPay")} now",
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
