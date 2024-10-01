import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class GasContainer extends ConsumerStatefulWidget {
  const GasContainer({super.key});

  @override
  ConsumerState<GasContainer> createState() => _GasContainerState();
}

class _GasContainerState extends ConsumerState<GasContainer> {
  late VideoPlayerController controller;

  int startPlaybackInMilliseconds = 0;
  final int startPlaybackOffset = 1600;
  final int animationPlaybackDuration = 2000;
  final int gasIncreaseSteps = 5;

  @override
  void initState() {
    super.initState();
    int currentGasLevel = ref.read(gasLevelProvider);
    startPlaybackInMilliseconds =
        (currentGasLevel ~/ gasIncreaseSteps) * animationPlaybackDuration;

    controller = VideoPlayerController.asset("assets/videos/gas.mp4")
      ..initialize().then((_) {
        setState(() {});
        controller.seekTo(Duration(milliseconds: startPlaybackInMilliseconds));
      });

    controller.addListener(() {
      int currentPosition = controller.value.position.inMilliseconds;
      if (currentPosition > startPlaybackInMilliseconds + startPlaybackOffset) {
        controller.seekTo(Duration(milliseconds: startPlaybackInMilliseconds));
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listenForChanges() {
    ref.listen(gasLevelProvider, (previous, next) {
      int targetStartInMilliseconds =
          (next ~/ gasIncreaseSteps) * animationPlaybackDuration;
      setState(() => startPlaybackInMilliseconds = targetStartInMilliseconds);
    });


    ref.listen(playGasAnimationProvider, (previous, next) {
      if(next) {
        controller.play();
      } else {
        controller.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listenForChanges();

    if (!controller.value.isInitialized) {
      return const SizedBox();
    }

    return SizedBox(
      width: 220.w,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      ),
    );
  }
}
