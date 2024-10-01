import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'drawer.dart';

class RegularHome extends ConsumerStatefulWidget {
  const RegularHome({super.key});

  @override
  ConsumerState<RegularHome> createState() => _RegularHomeState();
}

class _RegularHomeState extends ConsumerState<RegularHome> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    int index = ref.watch(pageIndexProvider);
    bool isPlayingAnimation = ref.watch(playGasAnimationProvider);
    User user = ref.watch(userProvider) as User;

    return Scaffold(
      key: scaffoldKey,
      drawer: EexilyUserDrawer(
        onCloseDrawer: () => scaffoldKey.currentState?.closeDrawer(),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: GestureDetector(
          onTap: () => scaffoldKey.currentState?.openDrawer(),
          child: Icon(
            IconsaxPlusBroken.menu_1,
            size: 26.r,
          ),
        ),
        actions: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: AssetImage(user.image),
          ),
          IconButton(
            onPressed: () => context.router.pushNamed(Pages.notification),
            icon: const Icon(
              IconsaxPlusBroken.notification_1,
              color: monokai,
            ),
            iconSize: 26.r,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
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
                const UserGasStatistics(),
                SizedBox(height: 5.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => context.router.pushNamed(Pages.gasUsage),
                    child: Text(
                      "View Usage",
                      style: context.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                const Center(child: GasContainer()),
                SizedBox(height: 10.h),
                Tooltip(
                  message:
                  "You're using the first version of our gas tracking feature. It might not always be perfect for now, but don’t worry—it gets better the more you use it. Over time, you'll see more accurate tracking and reminders. Thanks for being one of our early users and helping us make things better!",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: primary,
                        size: 14.r,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "Beta version",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              backgroundColor: primary,
              elevation: 1.0,
              onPressed: () {
                ref.watch(playGasAnimationProvider.notifier).state = !isPlayingAnimation;
              },
              child: AnimatedSwitcherTranslation.right(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isPlayingAnimation ? IconsaxPlusBroken.pause : IconsaxPlusBroken.play,
                  key: ValueKey<bool>(isPlayingAnimation),
                  color: Colors.white,
                  size: 32.r,
                ),
              ),
            )
          : null,
    );
  }
}
