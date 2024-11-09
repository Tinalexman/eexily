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
  final TextEditingController lastDateController = TextEditingController();
  final TextEditingController lastValueController = TextEditingController();

  DateTime? lastGasFilledDate;

  @override
  void initState() {
    super.initState();
    String lastFilledDate =
        ref.read(individualGasQuestionsProvider).lastGasFilledPeriod;
    if (lastFilledDate.isNotEmpty) {
      lastGasFilledDate = DateTime.parse(lastFilledDate);
      lastDateController.text = formatDateRaw(lastGasFilledDate!);
    }
    String lastFilledValue =
        ref.read(individualGasQuestionsProvider).lastGasFilledQuantity;
    lastValueController.text = lastFilledValue;
  }

  @override
  void dispose() {
    lastValueController.dispose();
    lastDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          controller: lastDateController,
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
                lastDateController.text = formatDateRaw(pickedDate);
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
        SpecialForm(
          controller: lastValueController,
          width: 375.w,
          hint: "e.g 3",
          type: TextInputType.number,
          onChange: (String value) {
            value = value.trim();
            ref.watch(individualGasQuestionsProvider.notifier).state =
                details.copyWith(lastGasFilledQuantity: value);
          },
        ),
      ],
    );
  }
}
