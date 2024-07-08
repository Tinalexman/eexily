import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class StartCookingPage extends ConsumerStatefulWidget {
  const StartCookingPage({super.key});

  @override
  ConsumerState<StartCookingPage> createState() => _StartCookingPageState();
}

class _StartCookingPageState extends ConsumerState<StartCookingPage> {
  final TextEditingController foodType = TextEditingController();
  final TextEditingController houseSize = TextEditingController();
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.asset("assets/videos/gas.mov")
      ..initialize().then(
        (_) => setState(() {}),
      );
  }

  @override
  void dispose() {
    videoController.dispose();
    foodType.dispose();
    houseSize.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.router.pop(),
          icon: const Icon(Icons.arrow_back),
          iconSize: 26.r,
        ),
        title: Text(
          "Start Cooking",
          style: context.textTheme.bodyLarge!.copyWith(
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
                SizedBox(height: 50.h),
                const Center(
                  child: GasTimer(),
                ),
                SizedBox(height: 50.h),
                Text(
                  "What are you cooking?",
                  style: context.textTheme.bodyMedium,
                ),
                SizedBox(height: 4.h),
                SpecialForm(
                  controller: foodType,
                  width: 375.w,
                  height: 50.h,
                  hint: "e.g Rice and Beans",
                ),
                SizedBox(height: 10.h),
                Text(
                  "How many people are you cooking for?",
                  style: context.textTheme.bodyMedium,
                ),
                SizedBox(height: 4.h),
                SpecialForm(
                  controller: houseSize,
                  width: 375.w,
                  height: 50.h,
                  type: TextInputType.number,
                  hint: "e.g 4",
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 250.h,
                  child: Stack(
                    children: [
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
                      Positioned(
                        bottom: 20.h,
                        left: 50.w,
                        child: SizedBox(
                          height: 160.h,
                          width: 6.w,
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: LinearProgressIndicator(
                              value: 0.5,
                              color: primary,
                              backgroundColor: neutral,
                              borderRadius: BorderRadius.circular(6.w),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
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
                    bool state = ref.watch(startGasTimerProvider);
                    ref.watch(startGasTimerProvider.notifier).state = !state;
                  },
                  child: Text(
                     "${ref.watch(startGasTimerProvider) ? "Stop" : "Start"} cooking",
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
