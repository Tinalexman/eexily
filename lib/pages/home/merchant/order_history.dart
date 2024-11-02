import 'package:eexily/components/filter_data.dart';
import 'package:eexily/components/sale_report.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/components/user/merchant.dart';
import 'package:eexily/tools/widgets/attendant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class History extends ConsumerStatefulWidget {
  const History({super.key});

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History> {
  FilterData? filterData;

  @override
  Widget build(BuildContext context) {
    Merchant attendant = ref.watch(userProvider) as Merchant;
    List<SaleReport> reports = ref.watch(saleReportsProvider);

    return BackButtonListener(
      onBackButtonPressed: () async {
        final canPop = context.router.canPop();
        if (!canPop) {
          ref.watch(pageIndexProvider.notifier).state = 0;
        }
        return !canPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sales",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              bottom: 10.h,
            ),
            child: Column(
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
                      String label =
                          index == 0 ? "Retail Price" : "Regular Price";
                      double price = index == 0
                          ? attendant.retailGasPrice
                          : attendant.regularGasPrice;
                      void onUpdate(double val) {
                        double regular = 0.0, retail = 0.0;
                        if (index == 0) {
                          regular = attendant.regularGasPrice;
                          retail = val;
                        } else {
                          retail = attendant.retailGasPrice;
                          regular = val;
                        }

                        // Merchant newAttendant = Merchant(
                        //   balance: attendant.balance,
                        //   retailGasPrice: retail,
                        //   regularGasPrice: regular,
                        // );
                        // ref.watch(userProvider.notifier).state = newAttendant;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Reports History",
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: monokai,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        FilterData? resp = await context.router
                            .pushNamed(Pages.filter) as FilterData?;
                        setState(() => filterData = resp);
                      },
                      icon: const Icon(
                        IconsaxPlusBroken.filter,
                        color: monokai,
                      ),
                      iconSize: 20.r,
                    )
                  ],
                ),
                if (filterData != null)
                  Chip(
                    label: Text(
                      filterData!.selection,
                      style: context.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    deleteIcon: Icon(
                      Boxicons.bx_x,
                      color: monokai,
                      size: 16.r,
                    ),
                    onDeleted: () => setState(() => filterData = null),
                    backgroundColor: secondary,
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5.r),
                    ),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                if (filterData != null) SizedBox(height: 10.h),
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
            ),
          ),
        ),
      ),
    );
  }
}
