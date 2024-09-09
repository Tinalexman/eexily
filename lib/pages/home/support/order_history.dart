import 'package:eexily/components/filter_data.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class OrderHistory extends ConsumerStatefulWidget {
  const OrderHistory({super.key});

  @override
  ConsumerState<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends ConsumerState<OrderHistory> {
  FilterData? filterData;

  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Order> history = ref.watch(orderHistoryProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "History",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: monokai,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpecialForm(
                  controller: controller,
                  width: 375.w,
                  height: 50.h,
                  hint: "Search orders",
                  prefix: Icon(
                    IconsaxPlusBroken.search_normal,
                    color: const Color(0xFFA9A9A9),
                    size: 20.r,
                  ),
                  suffix: GestureDetector(
                    onTap: () async {
                      FilterData? resp = await context.router
                          .pushNamed(Pages.filter) as FilterData?;
                      setState(() => filterData = resp);
                    },
                    child: Icon(
                      IconsaxPlusBroken.filter,
                      color: const Color(0xFFA9A9A9),
                      size: 20.r,
                    ),
                  ),
                  fillColor: const Color(0xFFF4F4F4),
                ),
                SizedBox(height: 10.h),
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
                  child: GridView.builder(
                    itemBuilder: (_, index) => OrderContainer(
                      order: history[index],
                      link: Pages.viewSupportOrder,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 165.h,
                      crossAxisSpacing: 10.h,
                      mainAxisSpacing: 10.h,
                    ),
                    itemCount: history.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(1),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
