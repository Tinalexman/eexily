import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,

        title: Text(
          "Help & Support",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We’re committed to making your experience with our app as smooth and enjoyable as possible. "
                  "If you encounter any issues, have complaints, or simply need assistance, "
                  "don’t hesitate to reach out. Your satisfaction is our top priority, and we’re here to help resolve your concerns quickly and efficiently.",
                  style: context.textTheme.bodyMedium!.copyWith(color: monokai),
                ),
                SizedBox(height: 30.h),
                Text(
                  "📞 Contact Us",
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: monokai,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "For assistance, please call us at ",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: monokai,
                          fontFamily: "WorkSans",
                        ),
                      ),
                      TextSpan(
                        text: "07011144686",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w500,
                          fontFamily: "WorkSans",
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchPhoneNumber("07011144686"),
                      ),
                      TextSpan(
                        text: " or at ",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: monokai,
                          fontFamily: "WorkSans",
                        ),
                      ),
                      TextSpan(
                        text: "09040342585",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w500,
                          fontFamily: "WorkSans",
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchPhoneNumber("09040342585"),
                      ),
                    ],
                  ),
                  textScaler: const TextScaler.linear(0.9),
                ),
                SizedBox(height: 20.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Alternatively, you could send us a mail at ",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: monokai,
                          fontFamily: "WorkSans",
                        ),
                      ),
                      TextSpan(
                        text: "info.gasfeel@gmail.com",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w500,
                          fontFamily: "WorkSans",
                        ),
                      ),
                    ],
                  ),
                  textScaler: const TextScaler.linear(0.9),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
