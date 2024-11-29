import 'package:eexily/api/attendant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class RegisterGasStationPage extends StatefulWidget {
  final String userId;
  const RegisterGasStationPage({
    super.key,
    required this.userId,
  });

  @override
  State<RegisterGasStationPage> createState() => _RegisterGasStationPageState();
}

class _RegisterGasStationPageState extends State<RegisterGasStationPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final Map<String, String> authDetails = {
    "gasStationName": "",
    "address": "",
    "location": "",
  };

  String? location;
  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }


  Future<void> createGasStation() async {
    var response = await updateAttendantUser(authDetails, widget.userId);
    setState(() => loading = false);
    showMessage(response.message, response.status ? primary : null);

    if (!response.status) {
      return;
    }

    navigate();
  }

  void navigate() {
    context.router.goNamed(Pages.setupAccount, extra: [widget.userId, "Attendant"]);
  }

  void showMessage(String message, [Color? backgroundColor]) => showToast(
    message,
    context,
    backgroundColor: backgroundColor,
  );


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
                SizedBox(height: 10.h),
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

                    if (location == null) {
                      showToast("Please choose a location", context);
                      return;
                    } else {
                      authDetails["location"] = location!;
                    }

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
