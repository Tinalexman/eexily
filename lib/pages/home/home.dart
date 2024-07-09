import 'package:eexily/components/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController videoController;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 26),
    );

    animationController.addListener(() {
      if (!ref.watch(shownGasToast) &&
          animationController.value >= 0.92 &&
          animationController.value <= 0.94) {
        ref.watch(shownGasToast.notifier).state = true;
        showToast(
          "WARNING: Gas Level Low!",
          context,
          backgroundColor: Colors.red,
        );
      }
    });

    videoController = VideoPlayerController.asset("assets/videos/gas.mov")
      ..initialize().then(
        (_) => setState(() {}),
      );
  }

  @override
  void dispose() {
    animationController.dispose();
    videoController.dispose();
    super.dispose();
  }

  String convertProgress(double value) {
    int difference = 98 - 15;
    double val = value * difference;
    val = 98 - val;
    return val.toStringAsFixed(0);
  }

  Color gasColor(double value) {
    if (value < 0.28) {
      return secondary2;
    } else if (value >= 0.28 && value <= 0.92) {
      return secondary;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    String firstName = ref.watch(userProvider.select((u) => u.firstName));
    String image = ref.watch(userProvider.select((u) => u.image));
    UserRole role = ref.watch(userProvider.select((u) => u.role));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0.h,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22.r,
                          backgroundColor: neutral2,
                          backgroundImage: AssetImage(image),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello $firstName",
                              style: context.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Welcome",
                              style: context.textTheme.bodyMedium,
                            )
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => context.router.pushNamed(Pages.notification),
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      ),
                      iconSize: 26.r,
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                const GasTrackerContainer(),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 7.5.r,
                          height: 7.5.r,
                          decoration: const BoxDecoration(
                            color: secondary4,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 7.5.w),
                        Text(
                          "In use",
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: secondary4,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 50.r,
                      height: 50.r,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: gasColor(animationController.value)),
                      alignment: Alignment.center,
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) => Text(
                          "${convertProgress(animationController.value)}%",
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 350.h,
                  child: Stack(
                    children: [
                      // Image.asset(
                      //   "assets/images/Logo Mark.png",
                      //   height: 350.h,
                      //   width: 375.w,
                      //   fit: BoxFit.contain,
                      // ),
                      Center(
                        child: videoController.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: videoController.value.aspectRatio,
                                child: VideoPlayer(videoController),
                              )
                            : const CircularProgressIndicator(
                                color: primary,
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                if (role == UserRole.regular)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      elevation: 1.0,
                      fixedSize: Size(375.w, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.5.r),
                      ),
                    ),
                    onPressed: () =>
                        context.router.pushNamed(Pages.startCooking),
                    child: Text(
                      "Start cooking",
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
