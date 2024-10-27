import 'package:eexily/components/gas_questions.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class StepSeven extends ConsumerStatefulWidget {
  const StepSeven({
    super.key,
  });

  @override
  ConsumerState<StepSeven> createState() => _StepSevenState();
}

class _StepSevenState extends ConsumerState<StepSeven> {
  final TextEditingController controller = TextEditingController();

  DateTime? lastGasFilledDate;

  @override
  void initState() {
    super.initState();
    String lastFilledDate =
        ref.read(individualGasQuestionsProvider).lastGasFilledPeriod;
    if (lastFilledDate.isNotEmpty) {
      lastGasFilledDate = DateTime.parse(lastFilledDate);
      controller.text = formatDateRaw(lastGasFilledDate!);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    IndividualGasQuestionsData details =
        ref.watch(individualGasQuestionsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "First Time User",
          style: context.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "When was the last time your filled gas?",
          style: context.textTheme.bodyLarge,
        ),
        SizedBox(height: 10.h),
        SpecialForm(
          controller: controller,
          width: 375.w,
          hint: "e.g Jan 1, 1960",
          readOnly: true,
          suffix: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                firstDate: DateUtilities.getThreeMonthsAgoStart(),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(
                        lastGasFilledPeriod: pickedDate.toIso8601String());
                controller.text = formatDateRaw(pickedDate);
                setState(() => lastGasFilledDate = pickedDate);
              }
            },
            child: Icon(
              IconsaxPlusBroken.calendar,
              size: 18.r,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "How much gas did your fill during the last purchase?",
          style: context.textTheme.bodyLarge,
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.lastGasFilledQuantity,
              groupValue: "3",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(lastGasFilledQuantity: "3");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "3kg",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.lastGasFilledQuantity,
              groupValue: "6",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(lastGasFilledQuantity: "6");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "6kg",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.lastGasFilledQuantity,
              groupValue: "12",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(lastGasFilledQuantity: "12");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "12kg",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.lastGasFilledQuantity,
              groupValue: "25",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(lastGasFilledQuantity: "25");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "25kg",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.lastGasFilledQuantity,
              groupValue: "50",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(lastGasFilledQuantity: "50");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "50kg",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
      ],
    );
  }
}
