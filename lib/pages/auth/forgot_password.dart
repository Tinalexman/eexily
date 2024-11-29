import 'package:eexily/api/authentication.dart';
import 'package:eexily/main.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();

  bool loading = false;

  final Map<String, String> authDetails = {
    "email": "",
  };

  Future<void> forgotPassword() async {
    var response = await forgot(authDetails);
    setState(() => loading = false);
    showMessage(response.message, response.status ? primary : null);

    if(response.status) {
      navigate(authDetails["email"]!);
    }
  }

  void navigate(String email) => context.router.pushNamed(Pages.resetPassword, extra: email);

  void showMessage(String message, [Color? color]) => showToast(
        message,
        context,
        backgroundColor: color,
      );

  @override
  void dispose() {
    emailController.dispose();
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
                  "Forgot your password?",
                  style: context.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: monokai.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 50.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email address",
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: 4.h),
                Form(
                  key: formKey,
                  child: SpecialForm(
                    controller: emailController,
                    width: 375.w,
                    type: TextInputType.emailAddress,
                    hint: "e.g johndoe@mail.com",
                    onValidate: (value) {
                      value = value.trim();
                      if (value!.isEmpty || !value.contains("@")) {
                        return 'Invalid Email Address';
                      }
                      return null;
                    },
                    onSave: (value) => authDetails["email"] = value!.trim(),
                  ),
                ),
                SizedBox(height: 350.h),
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
                    forgotPassword();
                  },
                  child: loading
                      ? whiteLoader
                      : Text(
                          "Verify Email",
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
