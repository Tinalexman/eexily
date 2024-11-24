import 'package:eexily/api/individual.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class UpdateCylinderPage extends ConsumerStatefulWidget {
  const UpdateCylinderPage({super.key});

  @override
  ConsumerState<UpdateCylinderPage> createState() => _UpdateCylinderPageState();
}

class _UpdateCylinderPageState extends ConsumerState<UpdateCylinderPage> {
  final TextEditingController sizeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  bool loading = false;

  final Map<String, dynamic> details = {
    "cylinderSize": "",
  };

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
  }

  Future<void> update() async {
    String id = ref.watch(userProvider.select((u) => u.id));
    var response = await updateIndividualUser(details, id);
    setState(() => loading = false);

    showMessage(response.message, response.status ? primary : null);

    if (response.status) {
      // int gasSize = ref.watch(gasCylinderSizeProvider);
      // int percentage =
      // gasSize <= 0 ? 0 : ((data.gasAmountLeft / gasSize) * 100).toInt();
      // ref.watch(gasLevelProvider.notifier).state = percentage;
      // ref.watch(gasEndingDateProvider.notifier).state = data.completionDate;
      //
      // ref.watch(playGasAnimationProvider.notifier).state = true;
      pop();
    }
  }

  void pop() => context.router.pop();

  void showMessage(String message, [Color? color]) => showToast(
        message,
        context,
        backgroundColor: color,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Update Cylinder",
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
                    "What is the size of your new gas cylinder?",
                    style: context.textTheme.bodyLarge,
                  ),
                  SizedBox(height: 10.h),
                  SpecialForm(
                    controller: sizeController,
                    width: 375.w,
                    hint: "e.g 3",
                    type: TextInputType.number,
                    onValidate: (String value) {
                      value = value.trim();
                      if (value.isEmpty) {
                        return 'Invalid Cylinder Size';
                      }
                      return null;
                    },
                    onSave: (value) => details["cylinderSize"] = value!.trim(),
                  ),
                  SizedBox(height: 400.h),
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
                            "Update Size",
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
