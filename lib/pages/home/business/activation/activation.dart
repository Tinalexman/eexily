import 'package:easy_stepper/easy_stepper.dart';
import 'package:eexily/api/individual.dart';
import 'package:eexily/components/gas_data.dart';
import 'package:eexily/components/gas_questions.dart';
import 'package:eexily/components/user/business.dart';
import 'package:eexily/pages/home/business/activation/step_four.dart';
import 'package:eexily/pages/home/business/activation/step_one.dart';
import 'package:eexily/pages/home/business/activation/step_three.dart';
import 'package:eexily/pages/home/business/activation/step_two.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessActivationPages extends ConsumerStatefulWidget {
  const BusinessActivationPages({super.key});

  @override
  ConsumerState<BusinessActivationPages> createState() => _BusinessActivationPagesState();
}

class _BusinessActivationPagesState extends ConsumerState<BusinessActivationPages> {
  int activeStep = 0;
  late List<Widget> children;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    children = const [
      StepOne(),
      StepTwo(),
      StepThree(),
      StepFour(),
    ];
  }

  double get bottomSpace {
    switch (activeStep) {
      case 0:
        return 250.h;
      case 1:
        return 290.h;
      case 3:
        return 240.h;
      default:
        return 40.h;
    }
  }

  void showMessage(String message, {Color? color}) =>
      showToast(message, context, backgroundColor: color);

  void pop() => context.router.pop();

  Future<void> createGasQuestions() async {
    BusinessGasQuestionsData details =
        ref.watch(businessGasQuestionsProvider);
    String id = ref.watch(userProvider).id;
    var response = await createIndividualGasQuestions(details.toJson(), id);
    setState(() => loading = false);
    showMessage(response.message, color: response.status ? primary : null);

    if (!response.status) return;

    Business user = ref.watch(userProvider) as Business;
    ref.watch(userProvider.notifier).state =
        user.copyWith(hasCompletedGas: true);

    GasData data = response.payload!;
    int gasSize = ref.watch(gasCylinderSizeProvider);
    int percentage =
        gasSize <= 0 ? 0 : ((data.gasAmountLeft / gasSize) * 100).toInt();
    ref.watch(gasLevelProvider.notifier).state = percentage;
    ref.watch(gasEndingDateProvider.notifier).state = data.completionDate;

    ref.watch(playGasAnimationProvider.notifier).state = true;
    pop();
  }

  bool get isPageValid {
    BusinessGasQuestionsData data = ref.watch(businessGasQuestionsProvider);
    // if (activeStep == 0) {
    //   return data.gasFilledPerTime != -1;
    // } else if (activeStep == 1) {
    //   return data.consumptionDuration.isNotEmpty;
    // } else if (activeStep == 2) {
    //   return data.gasUsagePeriod.isNotEmpty &&
    //       data.householdMeals.isNotEmpty &&
    //       data.cookingType.isNotEmpty;
    // } else if (activeStep == 3) {
    //   return data.householdSize.isNotEmpty &&
    //       data.householdType.isNotEmpty &&
    //       data.householdGender.isNotEmpty;
    // } else if (activeStep == 4) {
    //   return data.gasUsageAsidesCooking.isNotEmpty;
    // } else if (activeStep == 5) {
    //   return data.gasMonthlyRefill.isNotEmpty;
    // } else if (activeStep == 6) {
    //   return data.lastGasFilledPeriod.isNotEmpty &&
    //       data.lastGasFilledQuantity.isNotEmpty;
    // }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        if (activeStep != 0) {
          setState(() => activeStep--);
          return true;
        }

        return !context.router.canPop();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 100.h,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 70.h),
            child: EasyStepper(
              activeStep: activeStep,
              activeStepTextColor: Colors.white,
              finishedStepTextColor: Colors.white,
              internalPadding: 0,
              showLoadingAnimation: false,
              stepRadius: 12.r,
              showStepBorder: true,
              lineStyle: const LineStyle(
                lineSpace: 0,
                lineType: LineType.normal,
                defaultLineColor: primary50,
                finishedLineColor: primary,
              ),
              steps: List.generate(
                7,
                (index) => EasyStep(
                  customStep: CircleAvatar(
                    radius: 10.r,
                    backgroundColor: activeStep >= index ? primary : primary50,
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: context.textTheme.labelSmall!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              onStepReached: (index) => setState(() => activeStep = index),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  children[activeStep],
                  SizedBox(height: bottomSpace),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (activeStep != 0)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.5.r),
                            ),
                            side: const BorderSide(color: primary),
                            minimumSize: Size(150.w, 50.h),
                            fixedSize: Size(150.w, 50.h),
                          ),
                          onPressed: () {
                            if (loading) return;

                            if (activeStep != 0) {
                              setState(() => --activeStep);
                            }
                          },
                          child: Text(
                            "Back",
                            style: context.textTheme.titleMedium!.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.5.r),
                          ),
                          backgroundColor:
                              isPageValid ? primary : primary.withOpacity(0.6),
                          minimumSize:
                              Size((activeStep == 0 ? 335.w : 150.w), 50.h),
                          fixedSize:
                              Size((activeStep == 0 ? 335.w : 150.w), 50.h),
                        ),
                        onPressed: () {
                          if (!isPageValid) return;
                          if (loading) return;

                          if (activeStep != 3) {
                            setState(() => ++activeStep);
                          } else {
                            setState(() => loading = true);
                            createGasQuestions();
                          }
                        },
                        child: loading
                            ? whiteLoader
                            : Text(
                                activeStep == 3 ? "Complete" : "Next",
                                style: context.textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.router.pop(),
                      child: Text(
                        "Skip and Continue Later",
                        style: context.textTheme.titleMedium!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
