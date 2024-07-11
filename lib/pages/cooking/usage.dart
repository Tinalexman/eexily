import 'package:eexily/components/usage.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsagePage extends StatefulWidget {
  const UsagePage({
    super.key,
  });

  @override
  State<UsagePage> createState() => _UsagePageState();
}

class _UsagePageState extends State<UsagePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Usage",
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: GestureDetector(
                child: Text(
                  "Download",
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              TabBar(
                controller: controller,
                tabs: const [
                  Tab(text: "Daily"),
                  Tab(text: "Weekly"),
                  Tab(text: "Monthly"),
                ],
                labelStyle: context.textTheme.bodyMedium!.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
                dividerColor: Colors.black12,
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: TabBarView(
                  controller: controller,
                  children: const [
                    _UsageView(isYear: false),
                    _UsageView(isYear: false),
                    _UsageView(isYear: true),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _UsageView extends ConsumerStatefulWidget {
  final bool isYear;

  const _UsageView({
    super.key,
    required this.isYear,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DailyUsageViewState();
}

class _DailyUsageViewState extends ConsumerState<_UsageView> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    List<UsageData> usages = ref.watch(dailyUsages);

    return ListView.separated(
      itemBuilder: (_, index) {
        if (index == 0 && !widget.isYear) {
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const CustomDatePicker(),
              ).then((val) {
                if (val == null) return;
                setState(() => date = DateTime(val[1], val[0]));
              });
            },
            child: SizedBox(
              height: 40.h,
              child: Row(
                children: [
                  Text(
                    month(date.month.toString(), false),
                    style: context.textTheme.bodyLarge,
                  ),
                  SizedBox(width: 5.w),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 26.r,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          );
        } else if ((!widget.isYear && index == usages.length + 1) ||
            (widget.isYear && index == usages.length)) {
          return SizedBox(height: 40.h);
        }

        UsageData data = usages[index - (!widget.isYear ? 1 : 0)];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 35.h,
              width: 35.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: gasUsageContainerStart,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/burner.png",
                width: 36.r,
              ),
            ),
            if (!widget.isYear)
              Container(
                width: 140.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: gasUsageContainerEnd,
                  borderRadius: BorderRadius.circular(7.5.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 2.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Initial Volume",
                          style: context.textTheme.bodySmall!.copyWith(
                            color: gasUsageEndText,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          formatDateRaw(data.startTime, shorten: true),
                          style: context.textTheme.bodySmall!.copyWith(
                            color: gasUsageEndText.withOpacity(0.4),
                            fontSize: 10.sp,
                          ),
                        )
                      ],
                    ),
                    Text(
                      "${data.initialVolume.toStringAsFixed(1)}kg",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: gasUsageEndText,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            Container(
              width: !widget.isYear ? 140.w : 290.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: gasUsageContainerStart,
                borderRadius: BorderRadius.circular(7.5.r),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 2.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        !widget.isYear ? "Final Volume" : "Volume of gas used",
                        style: context.textTheme.bodySmall!.copyWith(
                          color: gasUsageStartText,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        !widget.isYear
                            ? formatDateRaw(data.endTime, shorten: true)
                            : "",
                        style: context.textTheme.bodySmall!.copyWith(
                          color: gasUsageStartText.withOpacity(0.4),
                          fontSize: 10.sp,
                        ),
                      )
                    ],
                  ),
                  Text(
                    "${data.finalVolume.toStringAsFixed(1)}kg",
                    style: context.textTheme.bodySmall!.copyWith(
                      color: gasUsageStartText,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemCount: usages.length + (!widget.isYear ? 2 : 1),
    );
  }
}