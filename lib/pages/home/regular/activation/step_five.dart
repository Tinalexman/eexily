import 'package:eexily/components/gas_questions.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepFive extends ConsumerStatefulWidget {
  const StepFive({
    super.key,
  });

  @override
  ConsumerState<StepFive> createState() => _StepFiveState();
}

class _StepFiveState extends ConsumerState<StepFive> {
  final TextEditingController controller = TextEditingController();
  String otherGasUsage = "";

  @override
  void initState() {
    super.initState();
    otherGasUsage =
        ref.read(individualGasQuestionsProvider).gasUsageAsidesCooking;
    controller.text = otherGasUsage;
  }

  @override
  void dispose() {
    controller.dispose();
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
          "Other Gas Usage",
          style: context.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "Do you gas for anything besides cooking?",
          style: context.textTheme.bodyLarge,
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.gasUsageAsidesCooking,
              groupValue: otherGasUsage.isEmpty ? "Yes" : otherGasUsage,
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(gasUsageAsidesCooking: "Yes");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "Yes",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        if (details.gasUsageAsidesCooking != "" &&
            details.gasUsageAsidesCooking != "No")
          SpecialForm(
            controller: controller,
            width: 375.w,
            hint: "Please specify",
            onChange: (val) {
              setState(() => otherGasUsage = val);
              ref.watch(individualGasQuestionsProvider.notifier).state =
                  details.copyWith(gasUsageAsidesCooking: val);
            },
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.gasUsageAsidesCooking,
              groupValue: "No",
              onChanged: (val) {
                setState(() => otherGasUsage = "");
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(gasUsageAsidesCooking: "No");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "No",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        SizedBox(height: 20.h),
        Text(
          "Do you use an oven or grill that runs on gas?",
          style: context.textTheme.bodyLarge,
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.grillOrOvenGasCooker,
              groupValue: "Yes",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(grillOrOvenGasCooker: "Yes");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "Yes",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.grillOrOvenGasCooker,
              groupValue: "No",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(grillOrOvenGasCooker: "No");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "No",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
      ],
    );
  }
}
