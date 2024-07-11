import 'package:eexily/components/points.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PointsSaverPage extends ConsumerStatefulWidget {
  final PointType type;

  const PointsSaverPage({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<PointsSaverPage> createState() => _PointsSaverPageState();
}

class _PointsSaverPageState extends ConsumerState<PointsSaverPage> {
  String filterValue = "All";

  @override
  Widget build(BuildContext context) {
    List<int> saverPoints = ref.watch(saverPointsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type == PointType.belly
              ? "Belly saver points"
              : "Gas saver points",
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/${widget.type == PointType.gas ? "Gold" : "Belly"} Saver.png",
                    width: 36.w,
                    height: 32.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 5.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.type == PointType.belly ? "Belly" : "Gas"} saver points",
                        style: context.textTheme.bodyMedium,
                      ),
                      Text(
                        "${saverPoints[widget.type == PointType.gas ? 0 : 1]}",
                        style: context.textTheme.headlineSmall!.copyWith(
                          color: widget.type == PointType.gas
                              ? primary
                              : bellySaver,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 30.h),
              Container(
                width: 375.w,
                height: 105.h,
                decoration: BoxDecoration(
                  color: widget.type == PointType.gas ? primary : bellySaver,
                  borderRadius: BorderRadius.circular(7.5.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 240.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5.r),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "1 ${widget.type == PointType.belly ? "BELLY" : "GAS"} SAVER POINT = 5 COINS",
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: widget.type == PointType.gas
                              ? primary
                              : bellySaver,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Cook now and earn ${widget.type == PointType.belly ? "belly" : "gas"} saver points",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 80.w,
                        height: 22.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE100),
                          borderRadius: BorderRadius.circular(11.h),
                        ),
                        child: Text(
                          "Use Now",
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: widget.type == PointType.gas
                                ? primary
                                : bellySaver,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "How to earn ${widget.type == PointType.belly ? "belly" : "gas"} saver points",
                    style: context.textTheme.bodySmall!.copyWith(
                      color:
                          widget.type == PointType.gas ? primary : bellySaver,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(
                    Icons.info_outline_rounded,
                    size: 10.r,
                    color: widget.type == PointType.gas ? primary : bellySaver,
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: ComboBox(
                  buttonPadding: EdgeInsets.symmetric(horizontal: 0.w),
                  hint: "All",
                  value: filterValue,
                  dropdownItems: [
                    "All",
                    "${widget.type == PointType.belly ? "Belly" : "Gas"} saver points earned",
                    "${widget.type == PointType.belly ? "Belly" : "Gas"} saver points used",
                    "${widget.type == PointType.belly ? "Belly" : "Gas"} saver points expired",
                  ],
                  dropdownWidth: 250.w,
                  icon: const RotatedBox(
                    quarterTurns: -1,
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  buttonWidth: filterValue == "All" ?  50.w : 230.w,
                  onChanged: (val) => setState(() => filterValue = val!),
                ),
              ),
              const Expanded(
                child: _PointsView(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PointsView extends ConsumerStatefulWidget {
  const _PointsView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PointsViewState();
}

class _PointsViewState extends ConsumerState<_PointsView> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    List<PointsTransaction> usages = ref.watch(pointsTransaction);

    return ListView.separated(
      itemBuilder: (_, index) {
        if (index == 0) {
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
        } else if (index == usages.length + 1) {
          return SizedBox(height: 40.h);
        }

        PointsTransaction data = usages[index - 1];

        return ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 0.w,
            vertical: 0.h,
          ),
          minTileHeight: 35.h,
          leading: Image.asset(
            "assets/images/${data.pointType == PointType.gas ? "Gold" : "Belly"} Saver.png",
            width: 36.w,
            height: 32.h,
            fit: BoxFit.cover,
          ),
          title: Text(
            "${data.pointType == PointType.gas ? "Gas" : "Belly"} saver points ${data.transactionType == PointTransactionType.expired ? "expired" : "earned"}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            formatDateRaw(data.timestamp),
            style: context.textTheme.bodySmall!.copyWith(
              color: neutral3,
            ),
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${data.amount > 0 ? "+" : ""}${data.amount}",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Total: ${data.total}",
                style: context.textTheme.bodyMedium!.copyWith(
                  color: primary.withOpacity(0.7),
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemCount: usages.length + 2,
    );
  }
}
