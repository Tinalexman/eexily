import 'package:eexily/api/file_handler.dart';
import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late bool animate;

  @override
  void initState() {
    super.initState();
    animate = false;
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(() => animate = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 375.w,
            height: 812.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Woman.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black45,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.bounceOut,
            top: animate ? 110.h : -50.h,
            left: 132.5.w,
            right: 132.5.w,
            child: Image.asset(
              "assets/images/GF A.png",
              width: 180.w,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            left: 22.5.w,
            right: 22.5.w,
            bottom: animate ? 60.h : -50.h,
            child: ElevatedButton(
              onPressed: () =>
                context.router.pushReplacementNamed(Pages.carousel)
              ,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(330.w, 50.h),
                fixedSize: Size(330.w, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5.r),
                ),
                elevation: 1.0,
                backgroundColor: secondary,
              ),
              child: Text(
                "Get Started",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: monokai,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
