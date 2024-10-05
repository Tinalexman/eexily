import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterBusinessPage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;

  const RegisterBusinessPage({
    super.key,
    required this.initialDetails,
  });

  @override
  State<RegisterBusinessPage> createState() => _RegisterBusinessPageState();
}

class _RegisterBusinessPageState extends State<RegisterBusinessPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final Map<String, String> authDetails = {
    "businessName": "",
    "phoneNumber": "",
    "address": "",
    "category": "",
  };

  bool loading = false, navigateToCategory = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    categoryController.dispose();
    businessNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> createBusiness() async {}

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
                  "Business Details",
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
                        "Business Name",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: businessNameController,
                        width: 375.w,
                        type: TextInputType.emailAddress,
                        hint: "e.g A&B Ventures",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid Business Name';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["businessName"] = value!.trim(),
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
                      Text(
                        "Category",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        width: 375.w,
                        controller: categoryController,
                        hint: "e.g Housing",
                        focus: FocusNode()
                          ..addListener(() async {
                            String? response = await context.router.pushNamed(
                              Pages.chooseBusinessCategory,
                              extra: categoryController.text,
                            );
                            unFocus();
                            if (response != null) {
                              setState(
                                  () => categoryController.text = response);
                            }
                          }),
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
                    createBusiness();
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
