import 'package:eexily/api/bank.dart';
import 'package:eexily/api/rider.dart';
import 'package:eexily/components/user/driver.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class EditRiderProfilePage extends ConsumerStatefulWidget {
  const EditRiderProfilePage({super.key});

  @override
  ConsumerState<EditRiderProfilePage> createState() =>
      _EditRiderProfilePageState();
}

class _EditRiderProfilePageState extends ConsumerState<EditRiderProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController licenseExpiryController = TextEditingController();

  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  final Map<String, String> authDetails = {
    "firstName": "",
    "lastName": "",
    "address": "",
    "driverLicense": "",
    "expiryDate": "",
    "accountName": "",
    "accountNumber": "",
  };

  String? type;
  DateTime? licenseExpiry;
  late List<String> optionKeys;

  String bankCode = "", bankName = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Driver driver = ref.read(userProvider) as Driver;
    firstNameController.text = driver.firstName;
    lastNameController.text = driver.lastName;
    addressController.text = driver.address;
    licenseController.text = preFormatLicenseNumber(driver.licenseNumber);
    licenseExpiryController.text = formatDateRaw(DateTime.parse(driver.licenseExpiry));
    accountNameController.text = driver.accountName;
    accountNumberController.text = driver.accountNumber;

    bankName = driver.bankName;
  }

  @override
  void dispose() {
    accountNumberController.dispose();
    accountNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    licenseController.dispose();
    licenseExpiryController.dispose();
    super.dispose();
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> updateRider() async {
    String id = ref.watch(userProvider.select((u) => u.id));
    var response = await updateRiderUser(authDetails, id);
    setState(() => loading = false);
    showMessage(response.message);

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

  String preFormatLicenseNumber(String license) {
    String first = license.substring(0, 4);
    String second = license.substring(4, 8);
    String third = license.substring(8, 12);
    String last = license.substring(12);
    return [first, second, third, last].join(" ");
  }

  void navigate() => context.router.pop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Edit Profile",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
                SizedBox(height: 20.h),
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
                        "Driver License Number",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: licenseController,
                        width: 375.w,
                        formatters: [
                          FourDigitGroupFormatter(),
                          LengthLimitingTextInputFormatter(19),
                        ],
                        hint: "e.g A1A1 B2B2 C3C3 D4D4",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty || value!.length != 19) {
                            return 'Invalid Driver License Number';
                          }

                          return null;
                        },
                        onSave: (String value) {
                          String format = value.trim().replaceAll(" ", "");
                          authDetails["driverLicense"] = format;
                        },
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Driver License Expiration",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: licenseExpiryController,
                        width: 375.w,
                        readOnly: true,
                        hint: "e.g Jan 1st, 1960",
                        suffix: GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateUtilities.getYearsAhead(10),
                            );

                            if (pickedDate != null) {
                              licenseExpiryController.text =
                                  formatDateRaw(pickedDate);
                              setState(() => licenseExpiry = pickedDate);
                            }
                          },
                          child: Icon(
                            IconsaxPlusBroken.calendar,
                            size: 18.r,
                            color: Colors.black87,
                          ),
                        ),
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty || licenseExpiry == null) {
                            return 'Invalid Driver License Expiration Date';
                          }

                          return null;
                        },
                        onSave: (value) => authDetails["expiryDate"] =
                            licenseExpiry!.toIso8601String(),
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
                      SizedBox(height: 20.h),
                      Text(
                        "Account Information",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: monokai,
                        ),
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
                    if (!validateForm(formKey) || loading) return;
                    setState(() => loading = true);
                    updateRider();
                  },
                  child: loading
                      ? whiteLoader
                      : Text(
                          "Save",
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
