import 'package:easy_stepper/easy_stepper.dart';
import 'package:eexily/api/individual.dart';
import 'package:eexily/components/gas_questions.dart';
import 'package:eexily/pages/home/regular/activation/step_five.dart';
import 'package:eexily/pages/home/regular/activation/step_four.dart';
import 'package:eexily/pages/home/regular/activation/step_one.dart';
import 'package:eexily/pages/home/regular/activation/step_seven.dart';
import 'package:eexily/pages/home/regular/activation/step_six.dart';
import 'package:eexily/pages/home/regular/activation/step_three.dart';
import 'package:eexily/pages/home/regular/activation/step_two.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivationPages extends ConsumerStatefulWidget {
  const ActivationPages({super.key});

  @override
  ConsumerState<ActivationPages> createState() => _ActivationPagesState();
}

class _ActivationPagesState extends ConsumerState<ActivationPages> {
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
      StepFive(),
      StepSix(),
      StepSeven(),
    ];
  }

  double get bottomSpace {
    switch (activeStep) {
      case 0:
        return 250.h;
      case 1:
        return 290.h;
      case 4:
        return 240.h;
      case 5:
        return 310.h;
      case 6:
        return 60.h;
      default:
        return 40.h;
    }
  }

  void showMessage(String message) => showToast(message, context);

  void pop() => context.router.pop();

  Future<void> createGasQuestions() async {
    IndividualGasQuestionsData details =
        ref.watch(individualGasQuestionsProvider);
    String id = ref.watch(userProvider).id;
    var response = await createIndividualGasQuestions(details.toJson(), id);
    setState(() => loading = false);
    if (!response.status) {
      showMessage(response.message);
      return;
    }

    // ref.watch(userProvider.notifier).state = response.payload!;
    // pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        backgroundColor: primary,
                        minimumSize:
                            Size((activeStep == 0 ? 335.w : 150.w), 50.h),
                        fixedSize:
                            Size((activeStep == 0 ? 335.w : 150.w), 50.h),
                      ),
                      onPressed: () {
                        if (activeStep != 6) {
                          setState(() => ++activeStep);
                        } else {
                          setState(() => loading = true);
                          createGasQuestions();
                        }
                      },
                      child: loading
                          ? whiteLoader
                          : Text(
                              activeStep == 6 ? "Complete" : "Next",
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
    );
  }
}
