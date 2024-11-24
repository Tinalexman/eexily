import 'package:eexily/api/business.dart';
import 'package:eexily/components/user/business.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class RegisterBusinessPage extends ConsumerStatefulWidget {
  const RegisterBusinessPage({
    super.key,
  });

  @override
  ConsumerState<RegisterBusinessPage> createState() =>
      _RegisterBusinessPageState();
}

class _RegisterBusinessPageState extends ConsumerState<RegisterBusinessPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final Map<String, String> authDetails = {
    "businessName": "",
    "address": "",
    "category": "",
    "location": "",
  };

  String? location;
  bool loading = false, navigateToCategory = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    categoryController.dispose();
    businessNameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> createBusiness() async {
    var response = await createBusinessUser(authDetails);
    setState(() => loading = false);
    if (!response.status) {
      showMessage(response.message);
      return;
    }

    Business business = ref.watch(userProvider) as Business;
    business.copyFrom(response.payload!);
    ref.watch(userProvider.notifier).state = business;
    navigate();
  }

  void navigate() => context.router.goNamed(Pages.home);

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
                  "Please fill in your details",
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
                        onValidate: (value) {
                          value = value.trim();
                          if (value!.isEmpty) {
                            return 'Invalid Business Category';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["category"] = value!.trim(),
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
                    if (location == null) {
                      showToast("Please choose a location", context);
                      return;
                    } else {
                      authDetails["location"] = location!;
                    }

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
