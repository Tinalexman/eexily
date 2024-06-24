import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  
  void goToOnboard() => context.router.pushReplacementNamed(Pages.onboard);
  
  Future<void> runAnimation() async {
    await controller.forward();
    await controller.reverse();
    goToOnboard();
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
          child: Image.asset("assets/images/LogoAndText.png"),
        ),
      ),
    );
  }
}
