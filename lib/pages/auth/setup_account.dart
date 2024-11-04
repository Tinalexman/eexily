import 'dart:developer';

import 'package:eexily/api/bank.dart';
import 'package:eexily/api/base.dart';
import 'package:eexily/api/merchant.dart';
import 'package:eexily/api/rider.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetupAccountPage extends StatefulWidget {
  final List<String> userData;

  const SetupAccountPage({
    super.key,
    required this.userData,
  });

  @override
  State<SetupAccountPage> createState() => _SetupAccountPageState();
}

class _SetupAccountPageState extends State<SetupAccountPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  final Map<String, String> authDetails = {
    "accountName": "",
    "accountNumber": ""
  };

  bool loading = false;

  String bankCode = "", bankName = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    accountNameController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  void showMessage(String message, {Color? backgroundColor}) => showToast(
        message,
        context,
        backgroundColor: backgroundColor,
      );

  Future<void> update() async {
    authDetails["bankName"] = bankName;

    String userId = widget.userData.first;
    String type = widget.userData[1];
    var response = type == "Rider"
        ? (await updateRiderUser(authDetails, userId))
        : (await updateMerchantUser(authDetails, userId));
    setState(() => loading = false);
    showMessage(response.message,
        backgroundColor: response.status ? primary : null);

    if (!response.status) {
      return;
    }

    navigate();
  }

  Future<void> getBankingInformation() async {
    String accountNumber = accountNumberController.text.trim();
    var response = await getBankInfo(accountNumber, bankCode);
    setState(() => loading = false);
    if (response.status) {
      accountNameController.text = response.payload!.first["account_name"];
    } else {
      showMessage("Could not locate your account");
      accountNameController.clear();
    }
  }

  void navigate() => context.router.goNamed(Pages.login);

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
                  "assets/images/GF B.png",
                  width: 140.w,
                  fit: BoxFit.cover,
                ),
                Text(
                  "Step 2 of 2",
                  style: context.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: monokai.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 50.h),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account Number",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: accountNumberController,
                        width: 375.w,
                        hint: "e.g 1234567890",
                        formatters: [LengthLimitingTextInputFormatter(10)],
                        type: TextInputType.number,
                        onChange: (String code) {
                          code = code.trim();
                          if (code.length == 10) {
                            unFocus();
                            if (bankCode.isNotEmpty) {
                              getBankingInformation();
                            }
                          }
                        },
                        onValidate: (String value) {
                          value = value.trim();
                          if (value.length != 10) {
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
                      GestureDetector(
                        onTap: () async {
                          Map<String, dynamic>? response =
                              await context.router.pushNamed(
                            Pages.selectBank,
                            extra: bankName,
                          );
                          unFocus();
                          if (response != null) {
                            setState(() {
                              bankName = response["bank_name"]!;
                              bankCode = response["code"]!;
                            });

                            if (accountNumberController.text.trim().length ==
                                10) {
                              setState(() => loading = true);
                              getBankingInformation();
                            }
                          }
                        },
                        child: Container(
                          width: 375.w,
                          height: kMinInteractiveDimension,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5.r),
                          ),
                          child: Text(
                            bankName.isEmpty ? "Select Bank" : bankName,
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: bankName.isEmpty
                                  ? FontWeight.w300
                                  : FontWeight.w500,
                              color:
                                  bankName.isEmpty ? Colors.black45 : monokai,
                            ),
                          ),
                        ),
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
                        readOnly: true,
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
                    if (loading) return;
                    if (!validateForm(formKey)) return;
                    setState(() => loading = true);
                    update();
                  },
                  child: loading
                      ? whiteLoader
                      : Text(
                          "Complete",
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
