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
            SizedBox(height: 80.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo blue.png",
                    width: 50.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "GasFeel",
                        style: context.textTheme.titleLarge!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Feel the difference",
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 80.h),
            ListTile(
              onTap: () {
                onCloseDrawer();
                logout(ref);
                context.router.goNamed(Pages.login);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Icon(
                IconsaxPlusLinear.logout,
                size: 30.r,
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
