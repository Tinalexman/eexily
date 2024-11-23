import 'package:eexily/components/gas_questions.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepOne extends ConsumerStatefulWidget {
  const StepOne({
    super.key,
  });

  @override
  ConsumerState<StepOne> createState() => _StepOneState();
}

class _StepOneState extends ConsumerState<StepOne> {
  @override
  Widget build(BuildContext context) {
    IndividualGasQuestionsData details =
        ref.watch(individualGasQuestionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current Gas Purchase",
          style: context.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "How much gas do you usually fill at a time?",
          style: context.textTheme.bodyLarge,
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.gasFilledPerTime,
              groupValue: 3,
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(gasFilledPerTime: 3);
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
              value: details.gasFilledPerTime,
              groupValue: 6,
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(gasFilledPerTime: 6);
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
              value: details.gasFilledPerTime,
              groupValue: 12,
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(gasFilledPerTime: 12);
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
              value: details.gasFilledPerTime,
              groupValue: 25,
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(gasFilledPerTime: 25);
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
              value: details.gasFilledPerTime,
              groupValue: 50,
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(gasFilledPerTime: 50);
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
