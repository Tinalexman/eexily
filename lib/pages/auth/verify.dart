import 'package:eexily/api/authentication.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyOTPPage extends StatefulWidget {
  final Map<String, String> config;

  const VerifyOTPPage({
    super.key,
    required this.config,
  });

  @override
  State<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  final List<TextStyle?> otpTextStyles = [];

  String otp = "";

  static const Color accentPurpleColor = Color(0xFF6A53A1);
  static const Color accentPinkColor = Color(0xFFF99BBD);
  static const Color accentDarkGreenColor = Color(0xFF115C49);
  static const Color accentYellowColor = Color(0xFFFFB612);
  static const Color accentOrangeColor = Color(0xFFEA7A3B);

  bool loading = false;
  bool verified = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (otpTextStyles.isEmpty) {
      otpTextStyles.add(createStyle(accentPurpleColor));
      otpTextStyles.add(createStyle(accentDarkGreenColor));
      otpTextStyles.add(createStyle(accentOrangeColor));
      otpTextStyles.add(createStyle(accentPinkColor));
      otpTextStyles.add(createStyle(accentYellowColor));
    }
  }

  TextStyle? createStyle(Color color) =>
      context.textTheme.displaySmall?.copyWith(color: color);

  Future<void> verifyAccount() async {
    var response = await verify({
      "otp": otp,
      "email": widget.config["email"]!,
    });

    setState(() => loading = false);
    showMessage(response.message, response.status ? primary : null);
    if (!response.status) return;

    setState(() => verified = true);
  }

  Future<void> resend() async {
    var response = await resendToken(widget.config["email"]!);
    showMessage(response.message);
    setState(() => loading = false);
  }

  void showMessage(String message, [Color? color]) => showToast(message, context, backgroundColor: color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Verification",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: verified ? 60.h : 20.h),
                Image.asset(
                  "assets/images/${verified ? "success" : "OTP"}.png",
                  width: 150.r,
                  height: 150.r,
                ),
                SizedBox(height: 20.h),
                if (verified)
                  Text(
                    "Your account has been verified",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (!verified)
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Enter the 5 digit code we sent to ",
                          style: context.textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: widget.config["email"],
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!verified) SizedBox(height: 20.h),
                if (!verified)
                  OtpTextField(
                    numberOfFields: 5,
                    styles: otpTextStyles,
                    showFieldAsBox: true,
                    fieldWidth: 45.w,
                    fieldHeight: 50.h,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                    keyboardType: TextInputType.number,
                    onCodeChanged: (verificationCode) =>
                        setState(() => otp = verificationCode),
                    onSubmit: (verificationCode) =>
                        setState(() => otp = verificationCode),
                  ),
                SizedBox(height: 10.h),
                if (!verified)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Didn't receive code?",
                          style: context.textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: " Resend code",
                          style: context.textTheme.bodySmall!.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() => loading = true);
                              resend();
                            },
                        )
                      ],
                    ),
                  ),
                SizedBox(height: verified ? 320.h : 280.h),
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
                    if (otp.length == 5) {
                      setState(() => loading = true);
                      verifyAccount();
                      return;
                    }

                    if (!verified) return;
                    context.router.goNamed(
                      widget.config["destination"]!,
                      extra: widget.config["userId"]!,
                    );
                  },
                  child: loading
                      ? whiteLoader
                      : Text(
                          verified ? "Proceed" : "Verify",
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
