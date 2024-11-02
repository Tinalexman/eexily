import 'package:cached_network_image/cached_network_image.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'drawer.dart';

class Home extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const Home({super.key, required this.scaffoldKey,});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {


  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userProvider) as User;
    bool hasCompletedGasQuestions = user.hasCompletedGasQuestions;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: GestureDetector(
          onTap: () => widget.scaffoldKey.currentState?.openDrawer(),
          child: Icon(
            IconsaxPlusBroken.menu_1,
            size: 26.r,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => context.router.pushNamed(Pages.individualProfile),
            child: CachedNetworkImage(
              imageUrl: user.image,
              errorWidget: (_, __, ___) => CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.redAccent,
              ),
              progressIndicatorBuilder: (_, __, ___) => CircleAvatar(
                radius: 20.r,
                backgroundColor: primary50,
              ),
              imageBuilder: (_, provider) => CircleAvatar(
                radius: 20.r,
                backgroundImage: provider,
              ),
            ),
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
                UserGasStatistics(hasCompleted: hasCompletedGasQuestions),
                SizedBox(height: 20.h),
                if (!hasCompletedGasQuestions)
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 80.h),
                        Image.asset(
                          "assets/images/error.png",
                          width: 200.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          "Gas tracker not activated!",
                          style: context.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () => context.router
                              .pushNamed(Pages.individualGasActivation),
                          child: Text(
                            "Click here to activate",
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                if (hasCompletedGasQuestions)
                  GestureDetector(
                    onTap: () => context.router.pushNamed(Pages.gasDetails),
                    child: const Center(child: GasContainer()),
                  ),
                SizedBox(height: 5.h),
                if (hasCompletedGasQuestions)
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
    );
  }
}
