import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterGasStationPage extends StatefulWidget {


  const RegisterGasStationPage({
    super.key,
  });

  @override
  State<RegisterGasStationPage> createState() => _RegisterGasStationPageState();
}

class _RegisterGasStationPageState extends State<RegisterGasStationPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  final Map<String, String> authDetails = {
    "gasStationName": "",
    "address": "",
  };

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    bankNameController.dispose();
    accountNameController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> createGasStation() async {}

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
                  "Gas Station Details",
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
                        "Gas Station Name",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: nameController,
                        width: 375.w,
                        hint: "e.g A&B Gas Industries",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid Gas Station Name';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["gasStationName"] = value!.trim(),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Account Name",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: accountNameController,
                        width: 375.w,
                        hint: "e.g John Doe",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid Bank Account Name';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["accountName"] = value!.trim(),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Account Number",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: accountNumberController,
                        width: 375.w,
                        hint: "e.g 1234567890",
                        type: TextInputType.number,
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid Account Number';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["accountNumber"] = value!.trim(),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Bank Name",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: bankNameController,
                        width: 375.w,
                        hint: "e.g First Bank",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid Bank Name';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["bankName"] = value!.trim(),
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
                SizedBox(height: 100.h),
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
                    createGasStation();
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
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
