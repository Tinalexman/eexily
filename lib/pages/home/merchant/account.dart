import 'package:eexily/components/filter_data.dart';
import 'package:eexily/components/transaction.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Account extends ConsumerStatefulWidget {
  const Account({super.key});

  @override
  ConsumerState<Account> createState() => _AccountState();
}

class _AccountState extends ConsumerState<Account> {
  bool active = true;
  FilterData? filterData;

  @override
  Widget build(BuildContext context) {
    List<Transaction> transactions = ref.watch(transactionsProvider);

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
            "Account",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                logout(ref);
                context.router.goNamed(Pages.login);
              },
              icon: const Icon(
                IconsaxPlusBroken.logout,
                color: monokai,
              ),
              iconSize: 26.r,
            ),
          ],
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
                const WalletSlider(),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Transactions",
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
                        TransactionContainer(transaction: transactions[index]),
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemCount: transactions.length,
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
