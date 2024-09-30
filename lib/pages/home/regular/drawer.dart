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
    Color selectedTileColor = primary50.withOpacity(0.2);
    int currentTile = ref.watch(pageIndexProvider);

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
                  Text(
                    "Everything made easy",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            ListTile(
              onTap: () {
                ref.watch(pageIndexProvider.notifier).state = 0;
                onCloseDrawer();
              },
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
              tileColor: currentTile == 0 ? selectedTileColor : null,
            ),
            ListTile(
              onTap: () {
                ref.watch(pageIndexProvider.notifier).state = 1;
                onCloseDrawer();
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
              tileColor: currentTile == 1 ? selectedTileColor : null,
            ),
            ListTile(
              onTap: () {
                // ref.watch(pageIndexProvider.notifier).state = 1;
                onCloseDrawer();
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Icon(
                IconsaxPlusBroken.cup,
                size: 26.r,
              ),
              title: Text(
                "My AI",
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                ref.watch(pageIndexProvider.notifier).state = 2;
                onCloseDrawer();
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Icon(
                IconsaxPlusBroken.devices,
                size: 26.r,
              ),
              title: Text(
                "Device",
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              tileColor: currentTile == 2 ? selectedTileColor : null,
            ),
            ListTile(
              onTap: () {
                ref.watch(pageIndexProvider.notifier).state = 3;
                onCloseDrawer();
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
              tileColor: currentTile == 3 ? selectedTileColor : null,
            ),
            ListTile(
              onTap: () {
                onCloseDrawer();
                context.router.pushNamed(Pages.individualGasActivation);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Icon(
                IconsaxPlusBroken.setting,
                size: 26.r,
              ),
              title: Text(
                "Gas Activation",
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
