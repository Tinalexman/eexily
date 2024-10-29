import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:eexily/api/authentication.dart';
import 'package:eexily/api/file_handler.dart';
import 'package:eexily/components/gas_data.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends ConsumerStatefulWidget {
  final Map<String, String>? savedDetails;
  const LoginPage({super.key, this.savedDetails,});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Map<String, String> authDetails = {
    "email": "",
    "password": "",
  };

  bool showPassword = false, remember = false, loading = false;



  @override
  void initState() {
    super.initState();
    if(widget.savedDetails != null) {
      Future.delayed(Duration.zero, autoLogin);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  void showMessage(String message) => showToast(message, context);

  Future<void> logIn() async {
    var response = await login(authDetails);
    setState(() => loading = false);
    if(!response.status) {
      showMessage(response.message);
      return;
    }

    if(remember) {
      FileHandler.saveAuthDetails(authDetails);
    }

    _processResponse(response);
  }

  void navigate() => context.router.goNamed(Pages.home);

  void _processResponse(response) {
    ref.watch(userProvider.notifier).state = response.payload![0];
    GasData data = response.payload![1];

    ref.watch(gasCylinderSizeProvider.notifier).state = data.gasSize;
    int percentage = data.gasSize == 0 ? 0 : ((data.gasAmountLeft / data.gasSize) * 100).toInt();
    ref.watch(gasLevelProvider.notifier).state = percentage;
    ref.watch(gasEndingDateProvider.notifier).state = data.completionDate;

    navigate();
  }


  Future<void> autoLogin() async {
    String savedEmail = widget.savedDetails!["email"]!;
    String savedPassword = widget.savedDetails!["password"]!;

    setState(() {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      remember = true;
      loading = true;
    });

    authDetails["email"] = savedEmail;
    authDetails["password"] = savedPassword;

    var response = await login(authDetails);
    setState(() => loading = false);
    showMessage(response.message);

    if(!response.status) {
      return;
    }

    _processResponse(response);
  }

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
                SizedBox(height: 40.h),
                Image.asset(
                  "assets/images/logo blue.png",
                  width: 40.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Sign In",
                  style: context.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                Text(
                  "Welcome back!",
                  style: context.textTheme.bodyLarge!.copyWith(
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
                        "Email address",
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
                        onSave: (value) => authDetails["password"] = value!.trim(),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: remember,
                            onChanged: (val) {
                              if(!loading) {
                                setState(() => remember = !remember);
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            side: const BorderSide(
                              color: monokai,
                              width: 1.5,
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

                    if(loading) return;
                    setState(() => loading = true);
                    logIn();
                  },
                  child: loading ? whiteLoader : Text(
                    "Sign in",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account?",
                        style: context.textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: " Register",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w500,
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
