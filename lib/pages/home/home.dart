import 'package:eexily/tools/constants.dart';
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

class _HomepageState extends ConsumerState<Homepage> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset("assets/videos/gas.mp4")
      ..initialize().then((_) => setState(() {}))
      ..play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String firstName = ref.watch(userProvider.select((u) => u.firstName));

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
                          backgroundImage:
                              const AssetImage("assets/images/user.png"),
                        ),
                        SizedBox(width: 5.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Hello $firstName",
                                  style: context.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 7.5.w),
                                Container(
                                  width: 7.5.r,
                                  height: 7.5.r,
                                  decoration: const BoxDecoration(
                                    color: secondary2,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 7.5.w),
                                Text(
                                  "Premium user",
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: secondary2,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
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
                      onPressed: () {},
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
                SizedBox(
                  height: 500.h,
                  child: Center(
                    child: controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          )
                        : const CircularProgressIndicator(
                            color: primary,
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
