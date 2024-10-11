import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({
    super.key,
  });

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cylinderSizeController = TextEditingController();
  final TextEditingController houseSizeController = TextEditingController();
  final TextEditingController applianceController = TextEditingController();

  final Map<String, dynamic> authDetails = {
    "firstName": "",
    "lastName": "",
    "address": "",
    "cylinderSize": "",
    "houseSize": "",
    "cookingAppliance": "",
  };

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    cylinderSizeController.dispose();
    houseSizeController.dispose();
    applianceController.dispose();
    super.dispose();
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> createUser() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 22.w,
            vertical: 10.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Image.asset(
                  "assets/images/logo blue.png",
                  width: 40.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10.h),
                Text(
                  "User Details",
                  style: context.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                SizedBox(height: 50.h),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full Name",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: fullNameController,
                        width: 375.w,
                        hint: "e.g John Doe",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid Full Name';
                          } else if (value.split(" ").length < 2) {
                            return 'Full name must contain both first and last names';
                          }

                          return null;
                        },
                        onSave: (value) {
                          List<String> names = value!.trim().split(" ");
                          authDetails["firstName"] = names[0];
                          authDetails["lastName"] = names[1];
                        },
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Phone Number (Whatsapp)",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: phoneNumberController,
                        type: TextInputType.phone,
                        width: 375.w,
                        hint: "e.g 080 1234 5678",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty || value.length != 11) {
                            return 'Invalid Phone Number';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["phoneNumber"] = value!.trim(),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cylinder Size",
                                style: context.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 4.h),
                              SpecialForm(
                                controller: cylinderSizeController,
                                type: TextInputType.number,
                                width: 150.w,
                                hint: "e.g 5",
                                onValidate: (value) {
                                  value = value.trim();
                                  if (value!.isEmpty) {
                                    return 'Invalid Cylinder Size';
                                  }
                                  return null;
                                },
                                onSave: (value) =>
                                    authDetails["cylinderSize"] = value!.trim(),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "House Size",
                                style: context.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 4.h),
                              SpecialForm(
                                controller: houseSizeController,
                                type: TextInputType.number,
                                width: 150.w,
                                hint: "e.g 2",
                                onValidate: (value) {
                                  value = value.trim();
                                  if (value!.isEmpty) {
                                    return 'Invalid House Size';
                                  }
                                  return null;
                                },
                                onSave: (value) =>
                                    authDetails["houseSize"] = value!.trim(),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Primary Cooking Appliance",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: applianceController,
                        type: TextInputType.text,
                        width: 375.w,
                        hint: "e.g Double faced gas cooker",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid Cooking Applicance';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["primaryApplicance"] = value!.trim(),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Address",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: addressController,
                        width: 375.w,
                        hint: "e.g No 12, Camp Junction, Alabata, Abeokuta",
                        maxLines: 3,
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid address';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["address"] = value!.trim(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
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
                    createUser();
                  },
                  child: loading
                      ? whiteLoader
                      : Text(
                          "Continue",
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
