import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const UserGasUsageGraph(),
            SizedBox(height: 20.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Likely running out on ",
                    style: context.textTheme.bodySmall,
                  ),
                  TextSpan(
                    text: "May 31st, 2002",
                    style: context.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
