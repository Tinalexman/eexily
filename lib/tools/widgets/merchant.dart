import 'package:eexily/api/merchant.dart';
import 'package:eexily/components/user/merchant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'common.dart';

class GasPriceContainer extends ConsumerStatefulWidget {
  const GasPriceContainer({super.key});

  @override
  ConsumerState<GasPriceContainer> createState() => _GasPriceContainerState();
}

class _GasPriceContainerState extends ConsumerState<GasPriceContainer> {
  void showModal(double currentPrice) {
    showDialog(
      context: context,
      builder: (context) => _PriceUpdate(
        price: currentPrice,
      ),
      useSafeArea: true,
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    Merchant merchant = ref.watch(userProvider) as Merchant;

    return Container(
      width: 375.w,
      height: 100.h,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 5.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current price of gas",
                style: context.textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => showModal(merchant.regularGasPrice),
                icon: const Icon(
                  IconsaxPlusBroken.edit,
                  color: Colors.white,
                ),
                iconSize: 20.r,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          Text(
            "₦${formatAmount(merchant.regularGasPrice.toStringAsFixed(0))}",
            style: context.textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceUpdate extends ConsumerStatefulWidget {
  final double price;

  const _PriceUpdate({
    super.key,
    required this.price,
  });

  @override
  ConsumerState<_PriceUpdate> createState() => _PriceUpdateState();
}

class _PriceUpdateState extends ConsumerState<_PriceUpdate> {
  late TextEditingController controller;
  FocusNode node = FocusNode();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.price.toStringAsFixed(0));
    node.requestFocus();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> updatePrice(double newPrice) async {
    Merchant merchant = ref.watch(userProvider) as Merchant;
    var response =
        await updateMerchantUser({"regularPrice": newPrice}, merchant.id);
    setState(() => loading = false);
    showMessage(response.message, response.status ? primary : null);

    if (response.status) {
      ref.watch(userProvider.notifier).state =
          merchant.copyWith(regularGasPrice: newPrice);
      pop();
      return;
    }
  }

  void pop() => Navigator.of(context).pop();

  void showMessage(String message, [Color? color]) =>
      showToast(message, context, backgroundColor: color);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "New Price",
                style: context.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: monokai,
                ),
              ),
              Text(
                "Update the prices of your gas",
                style: context.textTheme.bodyMedium!.copyWith(
                  color: monokai,
                ),
              ),
              SizedBox(height: 20.h),
              SpecialForm(
                controller: controller,
                width: 320.w,
                focus: node,
                type: TextInputType.number,
                hint: "New price",
                fillColor: neutral,
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      fixedSize: Size(130.w, 40.h),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "Cancel",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      fixedSize: Size(130.w, 40.h),
                    ),
                    onPressed: () {
                      String text = controller.text.trim();
                      double? value = double.tryParse(text);
                      if (text.isEmpty || value == null) return;

                      setState(() => loading = true);
                      updatePrice(value);
                    },
                    child: loading
                        ? whiteLoader
                        : Text(
                            "Update",
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  )
                ],
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}
