import 'package:eexily/components/filter_data.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  int currentFilterIndex = 0;

  final List<String> filterOptions = [
    "Custom Period",
    "This week",
    "Last week",
    "This month",
    "Last month",
    "Last 3 months",
  ];

  DateTime? startDate, endDate;

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  void onFilterChanged(int index) {
    switch (index) {
      case 1:
        startDate = DateUtilities.getCurrentWeekStart();
        endDate = DateUtilities.getCurrentWeekEnd();
        startController.text = DateFormat('dd/MM/yyyy').format(startDate!);
        endController.text = DateFormat('dd/MM/yyyy').format(endDate!);
        break;
      case 2:
        startDate = DateUtilities.getLastWeekStart();
        endDate = DateUtilities.getLastWeekEnd();
        startController.text = DateFormat('dd/MM/yyyy').format(startDate!);
        endController.text = DateFormat('dd/MM/yyyy').format(endDate!);
        break;
      case 3:
        startDate = DateUtilities.getCurrentMonthStart();
        endDate = DateUtilities.getCurrentMonthEnd();
        startController.text = DateFormat('dd/MM/yyyy').format(startDate!);
        endController.text = DateFormat('dd/MM/yyyy').format(endDate!);
        break;
      case 4:
        startDate = DateUtilities.getLastMonthStart();
        endDate = DateUtilities.getLastMonthEnd();
        startController.text = DateFormat('dd/MM/yyyy').format(startDate!);
        endController.text = DateFormat('dd/MM/yyyy').format(endDate!);
        break;
      case 5:
        startDate = DateUtilities.getThreeMonthsAgoStart();
        endDate = DateUtilities.getThreeMonthsAgoEnd();
        startController.text = DateFormat('dd/MM/yyyy').format(startDate!);
        endController.text = DateFormat('dd/MM/yyyy').format(endDate!);
        break;
      default:
        break;
    }

    setState(() => currentFilterIndex = index);
  }

  Future<void> onStartDateSelected() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: startDate ?? DateTime(2020),
      lastDate: endDate ?? DateTime.now(),
    );
    if (pickedDate != null) {
      startController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() => startDate = pickedDate);
    }
  }

  Future<void> onEndDateSelected() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: startDate ?? DateTime.now(),
      lastDate: endDate ?? DateTime(2050),
    );
    if (pickedDate != null) {
      endController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() => endDate = pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      bool selected = currentFilterIndex == index;
                      return GestureDetector(
                        onTap: () => onFilterChanged(index),
                        child: Chip(
                          label: Text(
                            filterOptions[index],
                            style: context.textTheme.bodySmall!.copyWith(
                              fontWeight:
                                  selected ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                          backgroundColor:
                              selected ? secondary : primary50.withOpacity(0.2),
                          elevation: selected ? 1.0 : 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.5.r),
                          ),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                    itemCount: filterOptions.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  "Start date",
                  style: context.textTheme.labelMedium!.copyWith(
                    color: monokai,
                  ),
                ),
                SpecialForm(
                  controller: startController,
                  width: 375.w,
                  height: 50.h,
                  hint: "dd/MM/yyyy",
                  readOnly: true,
                  suffix: GestureDetector(
                    onTap: onStartDateSelected,
                    child: const Icon(
                      IconsaxPlusBroken.calendar,
                      color: monokai,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "End date",
                  style: context.textTheme.labelMedium!.copyWith(
                    color: monokai,
                  ),
                ),
                SpecialForm(
                  controller: endController,
                  width: 375.w,
                  height: 50.h,
                  readOnly: true,
                  hint: "dd/MM/yyyy",
                  suffix: GestureDetector(
                    onTap: onEndDateSelected,
                    child: const Icon(
                      IconsaxPlusBroken.calendar,
                      color: monokai,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70.h,
        width: 375.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => setState(() {
                currentFilterIndex = 0;
                startDate = null;
                endDate = null;
                startController.clear();
                endController.clear();
              }),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150.w, 50.h),
                fixedSize: Size(150.w, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5.r),
                ),
                side: const BorderSide(color: primary),
                elevation: 1.0,
              ),
              child: Text(
                "Reset",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FilterData data = FilterData(
                  start: startDate,
                  end: endDate,
                  selection: filterOptions[currentFilterIndex]
                );
                context.router.pop(data);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150.w, 50.h),
                fixedSize: Size(150.w, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5.r),
                ),
                backgroundColor: primary,
                elevation: 1.0,
              ),
              child: Text(
                "Apply",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
