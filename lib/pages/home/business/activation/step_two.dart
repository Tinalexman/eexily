import 'package:eexily/components/gas_questions.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepTwo extends ConsumerStatefulWidget {
  const StepTwo({
    super.key,
  });

  @override
  ConsumerState<StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends ConsumerState<StepTwo> {
  @override
  Widget build(BuildContext context) {
    IndividualGasQuestionsData details =
        ref.watch(individualGasQuestionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Consumption Duration",
          style: context.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "How long does ${details.gasFilledPerTime}kg last you on average?",
          style: context.textTheme.bodyLarge,
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.consumptionDuration,
              groupValue: "Less than a week",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(consumptionDuration: "Less than a week");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "Less than a week",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.consumptionDuration,
              groupValue: "1-2 weeks",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(consumptionDuration: "1-2 weeks");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "1-2 weeks",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.consumptionDuration,
              groupValue: "3-4 weeks",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(consumptionDuration: "3-4 weeks");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "3-4 weeks",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.consumptionDuration,
              groupValue: "Over a month",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(consumptionDuration: "Over a month");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "Over a month",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
      ],
    );
  }
}
