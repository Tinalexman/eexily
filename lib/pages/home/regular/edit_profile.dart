import 'package:eexily/api/individual.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditIndividualProfilePage extends ConsumerStatefulWidget {
  const EditIndividualProfilePage({
    super.key,
  });

  @override
  ConsumerState<EditIndividualProfilePage> createState() =>
      _EditIndividualProfilePageState();
}

class _EditIndividualProfilePageState
    extends ConsumerState<EditIndividualProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController gasSizeController = TextEditingController();

  final Map<String, dynamic> authDetails = {
    "firstName": "",
    "lastName": "",
    "address": "",
    "gasSize": "",
    "user": "",
  };

  bool loading = false;

  @override
  void initState() {
    super.initState();
    authDetails["user"] = ref.read(userProvider).id;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    gasSizeController.dispose();
    super.dispose();
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> updateUser() async {
    var response =
        await updateIndividualUser(authDetails, ref.read(userProvider).id);
    setState(() => loading = false);
    showMessage(response.message);

    if (!response.status) {
      return;
    }

    navigate();
  }

  void navigate() => context.router.pop();

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
                        "Cylinder Size",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: gasSizeController,
                        width: 375.w,
                        hint: "e.g 5kg",
                        type: TextInputType.number,
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid Cylinder Size';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["gasSize"] = value!.trim(),
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
                    if (!validateForm(formKey) || loading) return;
                    setState(() => loading = true);
                    updateUser();
                  },
                  child: loading
                      ? whiteLoader
                      : Text(
                          "Update",
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
