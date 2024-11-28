import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class EexilyUserDrawer extends ConsumerWidget {
  final VoidCallback onCloseDrawer;

  const EexilyUserDrawer({
    super.key,
    required this.onCloseDrawer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: 270.w,
      elevation: 1.0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 60.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/GF B.png",
                    width: 120.w,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "Feel the difference",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  onTap: () {
                    onCloseDrawer();
                    context.router.pushNamed(Pages.help);
                  },
                  leading: Icon(
                    IconsaxPlusLinear.info_circle,
                    size: 24.r,
                  ),
                  title: Text(
                    "Help & Support",
                    style: context.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    onCloseDrawer();
                    logout(ref);
                    context.router.goNamed(Pages.splash);
                  },
                  leading: Icon(
                    IconsaxPlusLinear.logout,
                    size: 24.r,
                  ),
                  title: Text(
                    "Logout",
                    style: context.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
