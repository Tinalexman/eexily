import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  final String type;

  const RegisterPage({
    super.key,
    required this.type,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController address = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController cylinderSize = TextEditingController();
  final TextEditingController houseSize = TextEditingController();
  final TextEditingController cookingAppliance = TextEditingController();
  final TextEditingController password = TextEditingController();

  final Map<String, String> authDetails = {
    "email": "",
    "password": "",
    "firstName": "",
    "lastName": "",
  };

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool validPassword = false, passwordMatch = true;

  int page = 0;

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

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
                SizedBox(height: 30.h),
                Image.asset(
                  "assets/images/BlueLogoAndText.png",
                  width: 120.w,
                ),
                SizedBox(height: 5.h),
                Text(
                  "Register",
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 50.h),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: page == 0
                        ? [
                            Text(
                              "Full name",
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 4.h),
                            SpecialForm(
                              controller: fullName,
                              width: 375.w,
                              height: 50.h,
                              hint: "e.g John Doe",
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "E-mail address",
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 4.h),
                            SpecialForm(
                              controller: email,
                              width: 375.w,
                              height: 50.h,
                              type: TextInputType.emailAddress,
                              hint: "e.g johndoe@mail.com",
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Phone number (WhatsApp)",
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 4.h),
                            SpecialForm(
                              controller: phoneNumber,
                              width: 375.w,
                              height: 50.h,
                              type: TextInputType.phone,
                              hint: "e.g +2348012345678",
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Password",
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 4.h),
                            SpecialForm(
                              controller: password,
                              width: 375.w,
                              height: 50.h,
                              hint: "e.g ********",
                              maxLines: 1,
                              obscure: !showPassword,
                              suffix: GestureDetector(
                                onTap: () => setState(
                                    () => showPassword = !showPassword),
                                child: AnimatedSwitcherTranslation.right(
                                  duration: const Duration(milliseconds: 500),
                                  child: Icon(
                                    !showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 18.r,
                                    key: ValueKey<bool>(showPassword),
                                    color: darkTheme
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ]
                        : [
                            Text(
                              "Address",
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 4.h),
                            SpecialForm(
                              controller: address,
                              width: 375.w,
                              height: 50.h,
                              hint: "e.g House 12, Camp Junction, Abeokuta",
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Cylinder size",
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 4.h),
                            SpecialForm(
                              controller: cylinderSize,
                              width: 375.w,
                              height: 50.h,
                              type: TextInputType.number,
                              hint: "e.g 5",
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Household size",
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 4.h),
                            SpecialForm(
                              controller: houseSize,
                              width: 375.w,
                              height: 50.h,
                              type: TextInputType.number,
                              hint: "e.g 4",
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Primary cooking appliance",
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 4.h),
                            SpecialForm(
                              controller: cookingAppliance,
                              width: 375.w,
                              height: 50.h,
                              hint: "e.g Double faced gas cooker",
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
                    if (page == 0) {
                      setState(() => page = 1);
                    } else {
                      context.router.pushNamed(
                        Pages.verification,
                        extra: phoneNumber.text.trim(),
                      );
                    }
                  },
                  child: Text(
                    page == 0 ? "Continue" : "Register",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140.w,
                      child: Divider(
                        color: neutral2,
                        thickness: 1.h,
                      ),
                    ),
                    Text(
                      "OR",
                      style: context.textTheme.bodyLarge,
                    ),
                    SizedBox(
                      width: 140.w,
                      child: Divider(
                        color: neutral2,
                        thickness: 1.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Container(
                  width: 375.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: darkTheme ? neutral : Colors.white,
                    border: Border.all(color: primary50),
                    borderRadius: BorderRadius.circular(7.5.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/Google.png",
                        width: 40.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Continue with Google",
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Have an account already?",
                        style: context.textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: " Sign in",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              context.router.pushReplacementNamed(Pages.login),
                      ),
                    ],
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
