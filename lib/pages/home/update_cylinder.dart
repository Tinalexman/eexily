import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class UpdateCylinderPage extends StatefulWidget {
  const UpdateCylinderPage({super.key});

  @override
  State<UpdateCylinderPage> createState() => _UpdateCylinderPageState();
}

class _UpdateCylinderPageState extends State<UpdateCylinderPage> {
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
    setState(() => loading = false);
  }

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
                    "Changed your gas cylinder?",
                    style: context.textTheme.titleLarge!.copyWith(
                      color: monokai,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "You can update the size of your gas cylinder. "
                    "Please note that your gas predictions would be deleted and you would have to fill in a new set of details.",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: monokai,
                    ),
                  ),
                  SizedBox(height: 30.h),
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
                    onSave: (value) => details["amountValue"] = value!.trim(),
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
