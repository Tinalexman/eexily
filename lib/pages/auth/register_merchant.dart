import 'package:eexily/api/merchant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class RegisterMerchantPage extends StatefulWidget {
  final String userId;

  const RegisterMerchantPage({
    super.key,
    required this.userId,
  });

  @override
  State<RegisterMerchantPage> createState() => _RegisterMerchantPageState();
}

class _RegisterMerchantPageState extends State<RegisterMerchantPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController retailController = TextEditingController();
  final TextEditingController regularController = TextEditingController();

  final Map<String, dynamic> authDetails = {
    "storeName": "",
    "address": "",
    "firstName": "",
    "lastName": "",
    "retailPrice": 0,
    "regularPrice": 0,
    "location": "",
  };

  String? location;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    retailController.dispose();
    regularController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void showMessage(String message, {Color? backgroundColor}) => showToast(
        message,
        context,
        backgroundColor: backgroundColor,
      );

  Future<void> createMerchant() async {
    var response = await updateMerchantUser(authDetails, widget.userId);
    setState(() => loading = false);
    showMessage(response.message,
        backgroundColor: response.status ? primary : null);

    if (!response.status) {
      return;
    }

    navigate();
  }

  void navigate() {
    context.router.goNamed(Pages.setupAccount, extra: [widget.userId, "Merchant"]);
  }

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
                  "Step 1 of 2",
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
                        "First Name",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: firstNameController,
                        width: 375.w,
                        hint: "e.g Doe",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid First Name';
                          }

                          return null;
                        },
                        onSave: (value) =>
                            authDetails["firstName"] = value!.trim(),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Last Name",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: lastNameController,
                        width: 375.w,
                        hint: "e.g John",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid Last Name';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["lastName"] = value!.trim(),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Store Name",
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
                            return 'Invalid Store Name';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["storeName"] = value!.trim(),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Retail Price",
                                style: context.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 4.h),
                              SpecialForm(
                                controller: retailController,
                                width: 150.w,
                                hint: "e.g 1000",
                                type: TextInputType.number,
                                formatters: [
                                  DigitGroupFormatter(),
                                ],
                                onValidate: (value) {
                                  value = value.trim();
                                  if (value!.isEmpty) {
                                    return 'Invalid Price';
                                  }
                                  return null;
                                },
                                onSave: (String value) => authDetails[
                                    "retailPrice"] = double.tryParse(
                                        value.trim().replaceAll(",", "")) ??
                                    0,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Regular Price",
                                style: context.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 4.h),
                              SpecialForm(
                                controller: regularController,
                                width: 150.w,
                                hint: "e.g 1000",
                                type: TextInputType.number,
                                formatters: [
                                  DigitGroupFormatter(),
                                ],
                                onValidate: (value) {
                                  value = value.trim();
                                  if (value!.isEmpty) {
                                    return 'Invalid Price';
                                  }
                                  return null;
                                },
                                onSave: (String value) => authDetails[
                                    "regularPrice"] = double.tryParse(
                                        value.trim().replaceAll(",", "")) ??
                                    0,
                              ),
                            ],
                          ),
                        ],
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
                      SizedBox(height: 10.h),
                      Text(
                        "Location",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      ComboBox(
                        onChanged: (val) => setState(() => location = val),
                        value: location,
                        dropdownItems: allLocations,
                        hint: "Select Location",
                        dropdownWidth: 330.w,
                        icon: const Icon(
                          IconsaxPlusLinear.arrow_down,
                          color: monokai,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 70.h),
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

                    if (location == null) {
                      showToast("Please choose a location", context);
                      return;
                    } else {
                      authDetails["location"] = location!;
                    }

                    if (loading) return;
                    setState(() => loading = true);
                    createMerchant();
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
