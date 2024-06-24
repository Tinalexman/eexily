import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Register",
                  style: context.textTheme.headlineMedium,
                ),
                SizedBox(height: 5.h),
                Text(
                  "Welcome to Eexily",
                  style: context.textTheme.bodyMedium!.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 30.h),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full name",
                        style: context.textTheme.bodySmall,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: fullName,
                        width: 375.w,
                        height: 50.h,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "E-mail address",
                        style: context.textTheme.bodySmall,
                      ),
                      SizedBox(height: 4.h),
                      SpecialForm(
                        controller: email,
                        width: 375.w,
                        height: 50.h,
                        type: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
