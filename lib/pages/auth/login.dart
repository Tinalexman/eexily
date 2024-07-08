import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  };

  bool showPassword = false, remember = false;

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 22.w,
            vertical: 40.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/${darkTheme ? "" : "Blue"}LogoAndText.png",
                  width: 120.w,
                ),
                SizedBox(height: 30.h),
                Text(
                  "Sign in",
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: darkTheme ? Colors.white : primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 30.h),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          onTap: () =>
                              setState(() => showPassword = !showPassword),
                          child: AnimatedSwitcherTranslation.right(
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              !showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 18.r,
                              key: ValueKey<bool>(showPassword),
                              color:
                                  darkTheme ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: remember,
                            onChanged: (val) =>
                                setState(() => remember = !remember),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            side: BorderSide(
                              color: darkTheme ? Colors.white : monokai,
                              width: 1.0,
                            ),
                          ),
                          Text(
                            "Remember me",
                            style: context.textTheme.bodyMedium,
                          )
                        ],
                      )
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
                    showToast("Welcome back to Eexily", context);
                    Future.delayed(
                      const Duration(seconds: 1),
                      () => context.router.pushReplacementNamed(Pages.home),
                    );
                  },
                  child: Text(
                    "Sign in",
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
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account?",
                        style: context.textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: " Register",
                        style: context.textTheme.bodySmall!.copyWith(
                          color: primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.router
                              .pushReplacementNamed(Pages.register),
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
