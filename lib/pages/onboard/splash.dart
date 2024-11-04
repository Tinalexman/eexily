import 'package:eexily/api/file_handler.dart';
import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );

    runAnimation();
  }

  void navigate(Map<String, String>? data) {
    if (data != null) {
      context.router.pushReplacementNamed(
        Pages.login,
        extra: data,
      );
    } else {
      context.router.pushReplacementNamed(Pages.onboard);
    }
  }

  Future<void> loadAuthData() async {
    Map<String, String>? data = await FileHandler.loadAuthDetails();
    navigate(data);
  }

  Future<void> runAnimation() async {
    await controller.forward();
    await controller.reverse();
    loadAuthData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: FadeTransition(
        opacity: animation,
        child: Center(
          child: Image.asset(
            "assets/images/GF A.png",
            width: 200.w,
          ),
        ),
      ),
    );
  }
}
