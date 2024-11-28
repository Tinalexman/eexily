import 'package:eexily/api/bank.dart';
import 'package:eexily/api/merchant.dart';
import 'package:eexily/components/user/merchant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class EditMerchantProfilePage extends ConsumerStatefulWidget {
  const EditMerchantProfilePage({super.key});

  @override
  ConsumerState<EditMerchantProfilePage> createState() =>
      _EditMerchantProfilePageState();
}

class _EditMerchantProfilePageState
    extends ConsumerState<EditMerchantProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController storeController = TextEditingController();

  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  final Map<String, String> authDetails = {
    "firstName": "",
    "lastName": "",
    "address": "",
    "merchantLicense": "",
    "expiryDate": "",
    "accountName": "",
    "accountNumber": "",
  };

  String? type, location;
  DateTime? licenseExpiry;
  late List<String> optionKeys;

  String bankCode = "", bankName = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Merchant merchant = ref.read(userProvider) as Merchant;
    firstNameController.text = merchant.firstName;
    lastNameController.text = merchant.lastName;
    addressController.text = merchant.address;
    storeController.text = merchant.storeName;
    accountNameController.text = merchant.accountName;
    accountNumberController.text = merchant.accountNumber;

    bankName = merchant.bankName;
  }

  @override
  void dispose() {
    accountNumberController.dispose();
    accountNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    storeController.dispose();
    super.dispose();
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> updateMerchant() async {
    String id = ref.watch(userProvider.select((u) => u.id));
    var response = await updateMerchantUser(authDetails, id);
    setState(() => loading = false);
    showMessage(response.message);

    if (!response.status) {
      return;
    }

    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String storeName = storeController.text.trim();
    String address = addressController.text.trim();
    String accountName = accountNameController.text.trim();
    String accountNumber = accountNumberController.text.trim();

    Merchant merchant = ref.watch(userProvider) as Merchant;
    ref.watch(userProvider.notifier).state = merchant.copyWith(
      firstName: firstName,
      lastName: lastName,
      storeName: storeName,
      address: address,
      bankName: bankName,
      accountName: accountName,
      accountNumber: accountNumber,
      location: location!,
    );

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
                        "Store Name",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: storeController,
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
                    if(location == null) {
                      showToast("Please choose a location", context);
                      return;
                    }

                    authDetails["location"] = location!;
                    setState(() => loading = true);
                    updateMerchant();
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
