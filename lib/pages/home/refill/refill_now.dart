import 'package:eexily/api/prices.dart';
import 'package:eexily/api/refill.dart';
import 'package:eexily/components/order.dart';
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

  String? location, refillTarget;

  @override
  void initState() {
    super.initState();
    setCurrentUserAddress();
    Future.delayed(Duration.zero, getCurrentPrices);
  }

  void setCurrentUserAddress() {
    String address = ref.read(userProvider.select((u) => u.address));
    location = ref.read(userProvider.select((u) => u.location));
    addressController.text = address;
  }

  Future<void> getCurrentPrices() async {
    var response = await getPrices();
    showMessage(response.message, response.status ? primary : null);

    setState(() {
      if (response.status) {
        currentPriceOfGas = response.payload!.merchantGasPrice;
        deliveryFee = response.payload!.expressDeliveryFee;
        priceMarkup = 100;
      }
      loading = false;
    });
  }

  @override
  void dispose() {
    addressController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void showMessage(String message, [Color? color]) =>
      showToast(message, context, backgroundColor: color);

  void calculateNewTotalAmount(String value) {
    int? targetQuantity = int.tryParse(value);
    if (targetQuantity != null) {
      fakeDiscount = priceMarkup * targetQuantity;
      fakePriceToPayForGas = (currentPriceOfGas + priceMarkup) * targetQuantity;
      actualGasAmount = (currentPriceOfGas * targetQuantity);
      totalAmountToPay = actualGasAmount + deliveryFee;
    } else {
      fakeDiscount = 0;
      actualGasAmount = 0;
      fakePriceToPayForGas = 0;
      totalAmountToPay = 0;
    }
    setState(() {});
  }

  Future<void> showSuccessModal(String url) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessModal(
        text: "You have successfully ordered for an express delivery",
        onDismiss: () {
          Navigator.of(context).pop();
          launchPayStackUrl(url);
        },
      ),
    );
    pop();
  }

  void pop() => context.router.pop();

  Future<void> createOrder() async {
    String id = ref.watch(userProvider.select((u) => u.id));
    String address = addressController.text.trim();
    int quantity = int.parse(quantityController.text.trim());

    Map<String, dynamic> data = {
      "pickupDate": DateTime.now().toIso8601String(),
      "quantity": quantity,
      "address": address,
      "location": location,
      "sellerType": refillTarget!.toUpperCase().replaceAll(" ", "_"),
      "price": (currentPriceOfGas * quantity),
      "deliveryFee": (deliveryFee * 0.4).toInt(),
      "paymentMethod": "Paystack",
      "user": id,
    };

    var response = await createExpressOrder(data);
    setState(() => loading = false);

    if (!response.status) {
      showMessage(response.message);
      return;
    }

    List<Order> orders = ref.watch(initialExpressOrdersProvider);
    ref.watch(initialExpressOrdersProvider.notifier).state = [
      response.payload!,
      ...orders,
    ];
    showSuccessModal(response.payload!.paymentUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Express",
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
                SizedBox(height: 20.h),
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
                SizedBox(height: 10.h),
                ComboBox(
                  hint: "Select location",
                  value: location,
                  dropdownItems: allLocations,
                  onChanged: (value) {
                    if (shouldMakeAddressEditable) {
                      setState(() => location = value);
                    }
                  },
                  buttonDecoration: BoxDecoration(
                    color: shouldMakeAddressEditable ? Colors.white : neutral,
                    borderRadius: BorderRadius.circular(7.5.r),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Where do you want your gas to be refilled?",
                  style: context.textTheme.bodyMedium,
                ),
                SizedBox(height: 4.h),
                ComboBox(
                  hint: "Select refill target",
                  value: refillTarget,
                  dropdownItems: const [
                    // "Gas Station",
                    "Merchant",
                  ],
                  onChanged: (value) => setState(() => refillTarget = value),
                ),
                SizedBox(height: 50.h),
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
                      text: TextSpan(children: [
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
                      ]),
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
                    Text(
                      "₦${formatAmount("${totalAmountToPay == 0 ? 0 : deliveryFee}")}",
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
                  onPressed: () {
                    String quantity = quantityController.text.trim();
                    if (quantity.isEmpty) {
                      showToast("Enter your desired gas quantity", context);
                      return;
                    } else if(refillTarget == null) {
                      showToast("Enter your refill target", context);
                      return;
                    } else if(deliveryFee == 0) {
                      showToast("Invalid gas prices. Please check your connection and reload this page.", context);
                      return;
                    }

                    setState(() => loading = true);
                    createOrder();
                  },
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
