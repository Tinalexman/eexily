import 'package:eexily/components/gas_questions.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepThree extends ConsumerStatefulWidget {
  const StepThree({super.key});

  @override
  ConsumerState<StepThree> createState() => _StepThreeState();
}

class _StepThreeState extends ConsumerState<StepThree> {
  @override
  Widget build(BuildContext context) {
    IndividualGasQuestionsData details =
        ref.watch(individualGasQuestionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cooking Habits",
          style: context.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "How often do you cook with gas?",
          style: context.textTheme.bodyLarge,
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.gasUsagePeriod,
              groupValue: "4-6",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(gasUsagePeriod: "4-6");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "4-6 days per week",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.gasUsagePeriod,
              groupValue: "1-3",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(gasUsagePeriod: "1-3");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "1-3 days per week",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.gasUsagePeriod,
              groupValue: "Less than once a week",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(gasUsagePeriod: "Less than once a week");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "Less than once a week",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        SizedBox(height: 20.h),
        Text(
          "How many meals does your household typically prepare daily?",
          style: context.textTheme.bodyLarge,
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.householdMeals,
              groupValue: "1",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(householdMeals: "1");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "1 meal per day",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.householdMeals,
              groupValue: "2",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(householdMeals: "2");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "2 meals per day",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.householdMeals,
              groupValue: "3",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(householdMeals: "3");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "3 meals per day",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.householdMeals,
              groupValue: "more than 3",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(householdMeals: "more than 3");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "More than 3 meals per day",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        SizedBox(height: 15.h),
        Text(
          "What type of cooking do you primarily do?",
          style: context.textTheme.bodyLarge,
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.cookingType,
              groupValue: "Light",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(cookingType: "Light");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "Light (Boiling water, reheating food)",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.cookingType,
              groupValue: "Moderate",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(cookingType: "Moderate");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "Moderate (Rice, soups, stews)",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: details.cookingType,
              groupValue: "Heavy",
              onChanged: (val) {
                ref.watch(individualGasQuestionsProvider.notifier).state =
                    details.copyWith(cookingType: "Heavy");
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              "Heavy (Large meals, cooking for events)",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
      ],
    );
  }
}
