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
          vertical: 10.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Eexily",
                    style: context.textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 40.h),
            ListTile(
              onTap: onCloseDrawer,
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Icon(
                IconsaxPlusBroken.home,
                size: 26.r,
              ),
              title: Text(
                "Home",
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                onCloseDrawer();
                context.router.pushNamed(Pages.refill);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Icon(
                IconsaxPlusBroken.gas_station,
                size: 26.r,
              ),
              title: Text(
                "Refill",
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                onCloseDrawer();
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Icon(
                IconsaxPlusBroken.cup,
                size: 26.r,
              ),
              title: Text(
                "Ask Cheffy",
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                onCloseDrawer();
                context.router.pushNamed(Pages.individualProfile);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Icon(
                IconsaxPlusBroken.profile,
                size: 26.r,
              ),
              title: Text(
                "Profile",
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 50.h),
            ListTile(
              onTap: () {
                onCloseDrawer();
                logout(ref);
                context.router.goNamed(Pages.login);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Icon(
                IconsaxPlusLinear.logout,
                size: 26.r,
              ),
              title: Text(
                "Logout",
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
