import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class RegisterRiderPage extends StatefulWidget {

  const RegisterRiderPage({
    super.key,
  });

  @override
  State<RegisterRiderPage> createState() => _RegisterRiderPageState();
}

class _RegisterRiderPageState extends State<RegisterRiderPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController licenseExpiryController = TextEditingController();
  final TextEditingController stationCodeController = TextEditingController();

  final Map<String, String> authDetails = {
    "firstName": "",
    "lastName": "",
    "address": "",
    "phoneNumber": "",
    "driverLicense": "",
    "expiryDate": "",
    "gasStation": "",
  };

  DateTime? licenseExpiry;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    licenseController.dispose();
    licenseExpiryController.dispose();
    stationCodeController.dispose();
    super.dispose();
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> createRider() async {}

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
                  "Rider Details",
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
                        hint: "e.g A1A1 B2B2 C3C3 D4D4",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty || value!.length != 16) {
                            return 'Invalid Driver License Number';
                          }

                          return null;
                        },
                        onSave: (value) =>
                            authDetails["driverLicense"] = value!.trim(),
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
                        "Gas Station Code",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: stationCodeController,
                        width: 375.w,
                        hint: "e.g XXXXXX",
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty || value!.length != 6) {
                            return 'Invalid Gas Station Code';
                          }

                          return null;
                        },
                        onSave: (value) =>
                            authDetails["gasStation"] = value!.trim(),
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
                    // if (!validateForm(formKey)) return;

                    context.router.pushNamed(
                      Pages.chooseDriverImage,
                      extra: {},
                    );
                  },
                  child: Text(
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
