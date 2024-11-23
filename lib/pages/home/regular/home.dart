import 'package:cached_network_image/cached_network_image.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    animation = Tween<Offset>(
      begin: const Offset(0, -0.02),
      end: const Offset(0, 0.02),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userProvider) as User;
    bool hasCompletedGasQuestions = user.hasCompletedGasQuestions;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Text(
            "Hello,",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "${user.firstName} ${user.lastName}!",
            style: context.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () => context.router.pushNamed(Pages.updateCylinder),
            child: UserGasStatistics(
              hasCompleted: hasCompletedGasQuestions,
            ),
          ),
          SizedBox(height: 20.h),
          if (!hasCompletedGasQuestions)
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h),
                  Image.asset(
                    "assets/images/error.png",
                    width: 200.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Oops :(",
                    style: context.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "You have not activated your gas tracker.",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontFamily: "WorkSans",
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () =>
                        context.router.pushNamed(Pages.individualGasActivation),
                    child: Text(
                      "Click to Activate",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontFamily: "WorkSans",
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (hasCompletedGasQuestions)
            SlideTransition(
              position: animation,
              child: GestureDetector(
                onTap: () => context.router.pushNamed(Pages.gasDetails),
                child: const Center(child: GasContainer()),
              ),
            ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
