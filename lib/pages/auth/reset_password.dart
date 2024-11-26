import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:eexily/api/authentication.dart';
import 'package:eexily/main.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool showPassword = false, showConfirmPassword = false, loading = false;

  final Map<String, String> authDetails = {
    "otp": "",
    "newPassword": "",
  };

  Future<void> resetPassword() async {
    var response = await reset(authDetails);
    setState(() => loading = false);
    showMessage(response.message, response.status ? primary : null);
    if(response.status) {
      navigate();
    }
  }

  void navigate() => context.router.goNamed(Pages.login);

  void showMessage(String message, [Color? color]) => showToast(
        message,
        context,
        backgroundColor: color,
      );

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    codeController.dispose();
    super.dispose();
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
          child: Form(
            key: formKey,
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
                    "Reset your password",
                    style: context.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: monokai.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Verification Code",
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: codeController,
                    width: 375.w,
                    type: TextInputType.number,
                    hint: "e.g XXXXX",
                    onValidate: (String value) {
                      value = value.trim();
                      if (value.isEmpty || value.length != 5) {
                        return 'Invalid Verification Code';
                      }
                      return null;
                    },
                    onSave: (value) => authDetails["otp"] = value!.trim(),
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: passwordController,
                    width: 375.w,
                    hint: "e.g ********",
                    maxLines: 1,
                    obscure: !showPassword,
                    suffix: GestureDetector(
                      onTap: () => setState(() => showPassword = !showPassword),
                      child: AnimatedSwitcherTranslation.right(
                        duration: const Duration(milliseconds: 500),
                        child: Icon(
                          !showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 18.r,
                          key: ValueKey<bool>(showPassword),
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    onValidate: (value) {
                      value = value.trim();
                      if (value!.isEmpty || value.length < 8) {
                        return 'Password should have at least 8 characters';
                      }
                      return null;
                    },
                    onSave: (value) => authDetails["newPassword"] = value!.trim(),
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm Password",
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: confirmPasswordController,
                    width: 375.w,
                    hint: "e.g ********",
                    maxLines: 1,
                    obscure: !showConfirmPassword,
                    suffix: GestureDetector(
                      onTap: () => setState(
                          () => showConfirmPassword = !showConfirmPassword),
                      child: AnimatedSwitcherTranslation.right(
                        duration: const Duration(milliseconds: 500),
                        child: Icon(
                          !showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 18.r,
                          key: ValueKey<bool>(showConfirmPassword),
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    onValidate: (value) {
                      value = value.trim();
                      if (passwordController.text.trim() != value) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 200.h),
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

                      if (loading) return;
                      setState(() => loading = true);
                      resetPassword();
                    },
                    child: loading
                        ? whiteLoader
                        : Text(
                            "Reset Password",
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
      ),
    );
  }
}
