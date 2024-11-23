import 'package:eexily/api/merchant.dart';
import 'package:eexily/components/filter_data.dart';
import 'package:eexily/components/sale_report.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/components/user/merchant.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets/attendant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Store extends ConsumerStatefulWidget {
  const Store({super.key});

  @override
  ConsumerState<Store> createState() => _StoreState();
}

class _StoreState extends ConsumerState<Store> {
  FilterData? filterData;
  bool loadingUpdatePrices = false;

  Future<void> modifyStore(
      double newRetailPrice, double newRegularPrice) async {
    Merchant merchant = ref.watch(userProvider) as Merchant;
    var response = await updateMerchantUser({
      "regularPrice": newRegularPrice,
      "retailPrice": newRetailPrice,
    }, merchant.id);
    setState(() => loadingUpdatePrices = false);

    if (!response.status) {
      showMessage(response.message);
      return;
    }

    ref.watch(userProvider.notifier).state = merchant.copyWith(
      regularGasPrice: newRegularPrice,
      retailGasPrice: newRetailPrice,
    );
  }

  void showMessage(String message, [Color? color]) => showToast(
        message,
        context,
        backgroundColor: color,
      );

  @override
  Widget build(BuildContext context) {
    Merchant merchant = ref.watch(userProvider) as Merchant;
    List<SaleReport> reports = ref.watch(saleReportsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 375.w,
          height: 102.h,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisExtent: 100.h,
            ),
            itemBuilder: (_, index) {
              String label = index == 0 ? "Retail Price" : "Regular Price";
              double price = index == 0
                  ? merchant.retailGasPrice
                  : merchant.regularGasPrice;

              void onUpdate(double val) {
                double regular = 0.0, retail = 0.0;
                if (index == 0) {
                  regular = merchant.regularGasPrice;
                  retail = val;
                } else {
                  retail = merchant.retailGasPrice;
                  regular = val;
                }

                modifyStore(retail, regular);
              }

              return SalePriceContainer(
                label: label,
                price: price,
                onPriceUpdated: onUpdate,
              );
            },
            itemCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(1),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Sales Reports",
          style: context.textTheme.bodyLarge!.copyWith(
            color: monokai,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(1),
            itemBuilder: (_, index) =>
                SaleReportContainer(report: reports[index]),
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemCount: reports.length,
          ),
        )
      ],
    );
  }
}
