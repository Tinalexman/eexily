import 'package:eexily/api/individual.dart';
import 'package:eexily/components/gas_data.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class LastRefillPage extends ConsumerStatefulWidget {
  const LastRefillPage({super.key});

  @override
  ConsumerState<LastRefillPage> createState() => _LastRefillPageState();
}

class _LastRefillPageState extends ConsumerState<LastRefillPage> {
  final TextEditingController lastDateController = TextEditingController();
  final TextEditingController lastValueController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  bool loading = false;

  final Map<String, dynamic> details = {
    "refillDate": "",
    "amountFilled": "",
  };

  DateTime? lastGasFilledDate;

  @override
  void dispose() {
    lastValueController.dispose();
    lastDateController.dispose();
    super.dispose();
  }

  Future<void> update() async {
    var response = await updateGasData(details);
    if (!context.mounted) return;
    showMessage(response.message, response.status ? primary : null);
    setState(() => loading = false);
    if (response.status) {
      GasData data = response.payload!;
      int gasSize = ref.watch(gasCylinderSizeProvider);
      int percentage =
          gasSize <= 0 ? 0 : ((data.gasAmountLeft / gasSize) * 100).toInt();
      ref.watch(gasLevelProvider.notifier).state = percentage;
      ref.watch(gasEndingDateProvider.notifier).state = data.completionDate;
      pop();
    }
  }

  void pop() => context.router.pop();

  void showMessage(String message, [Color? color]) =>
      showToast(message, context, backgroundColor: color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Refill Details",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    "When was the last time you refilled your gas?",
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
                    onValidate: (String value) {
                      value = value.trim();
                      if (value.isEmpty) {
                        return 'Invalid Refill Date';
                      }
                      return null;
                    },
                    onSave: (value) => details["refillDate"] =
                        lastGasFilledDate!.toIso8601String(),
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
                    onValidate: (String value) {
                      value = value.trim();
                      if (value.isEmpty) {
                        return 'Invalid Refill Amount';
                      }
                      return null;
                    },
                    onSave: (value) => details["amountFilled"] = value!.trim(),
                  ),
                  SizedBox(height: 350.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      elevation: 1.0,
                      fixedSize: Size(375.w, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.5.r),
                      ),
                    ),
                    onPressed: () {
                      if (!validateForm(formKey)) return;

                      if (loading) return;
                      setState(() => loading = true);
                      update();
                    },
                    child: loading
                        ? whiteLoader
                        : Text(
                            "Update Details",
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
