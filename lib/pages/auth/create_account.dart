import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:eexily/api/authentication.dart';
import 'package:eexily/components/user/base.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CreateAccountPage extends ConsumerStatefulWidget {
  const CreateAccountPage({super.key});

  @override
  ConsumerState<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final Map<String, String> authDetails = {
    "email": "",
    "password": "",
    "type": "",
  };

  final Map<String, String> options = {
    "Business": "BUSINESS",
    "Individual/Household": "INDIVIDUAL",
    "Driver/Rider": "RIDER",
    "Gas Station Attendant": "GAS_STATION",
    "Customer Support": "CUSTOMER_SERVICE",
  };

  late List<String> optionKeys;

  bool showPassword = false, showConfirmPassword = false, loading = false;

  String? type;

  @override
  void initState() {
    super.initState();
    optionKeys = options.keys.toList();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> createAccount() async {
    var response = await register(authDetails);
    setState(() => loading = false);
    if (!response.status) {
      showMessage(response.message);
      return;
    }

    ref.watch(userProvider.notifier).state = response.payload!;
    navigate();
  }

  void navigate() {
    String email = emailController.text.trim();
    String destination = "";
    if (type == optionKeys[0]) {
      destination = Pages.registerBusiness;
    } else if (type == optionKeys[1]) {
      destination = Pages.registerUser;
    } else if (type == optionKeys[2]) {
      destination = Pages.registerRider;
    } else if (type == optionKeys[3]) {
      destination = Pages.registerStation;
    } else if (type == optionKeys[4]) {
      destination = Pages.registerSupport;
    }
    context.router.goNamed(
      Pages.verification,
      extra: {
        "email": email,
        "destination": destination,
      },
    );
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
                  "assets/images/logo blue.png",
                  width: 40.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Sign Up",
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
                        "E-mail address",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
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
                      SizedBox(height: 10.h),
                      Text(
                        "Password",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: passwordController,
                        width: 375.w,
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
                        onSave: (value) =>
                            authDetails["password"] = value!.trim(),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Confirm Password",
                        style: context.textTheme.bodyMedium,
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
                      SizedBox(height: 10.h),
                      Text(
                        "Type",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                      ComboBox(
                        onChanged: (val) => setState(() => type = val),
                        value: type,
                        dropdownItems: optionKeys,
                        hint: "Select Type",
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

                    if (type == null) {
                      showToast("Please choose a user type", context);
                      return;
                    } else {
                      authDetails["type"] = options[type!]!;
                    }

                    if (loading) return;
                    setState(() => loading = true);
                    createAccount();
                  },
                  child: loading
                      ? whiteLoader
                      : Text(
                          "Create Account",
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
                SizedBox(height: 30.h),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       width: 140.w,
                //       child: Divider(
                //         color: neutral2,
                //         thickness: 1.h,
                //       ),
                //     ),
                //     Text(
                //       "OR",
                //       style: context.textTheme.bodyLarge,
                //     ),
                //     SizedBox(
                //       width: 140.w,
                //       child: Divider(
                //         color: neutral2,
                //         thickness: 1.h,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 15.h),
                // Container(
                //   width: 375.w,
                //   height: 50.h,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border.all(color: primary50),
                //     borderRadius: BorderRadius.circular(7.5.r),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Image.asset(
                //         "assets/images/Google.png",
                //         width: 40.w,
                //       ),
                //       SizedBox(width: 10.w),
                //       Text(
                //         "Continue with Google",
                //         style: context.textTheme.bodyLarge,
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 15.h),
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
                          fontWeight: FontWeight.w500,
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
