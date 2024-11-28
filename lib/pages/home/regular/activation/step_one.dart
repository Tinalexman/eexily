import 'package:eexily/components/gas_questions.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/common.dart';
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

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    IndividualGasQuestionsData details =
    ref.read(individualGasQuestionsProvider);
    controller.text = "${details.gasFilledPerTime}";
  }

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
        SpecialForm(
          controller: controller,
          width: 375.w,
          hint: "e.g 3",
          type: TextInputType.number,
          onChange: (String value) {
            value = value.trim();
            int? number = int.tryParse(value);
            ref.watch(individualGasQuestionsProvider.notifier).state =
                details.copyWith(gasFilledPerTime: number ?? 0);
          },
        ),
      ],
    );
  }
}
