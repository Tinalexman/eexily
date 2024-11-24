import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class _BottomBarClipper extends CustomClipper<Path> {
  final double radius;
  final double curve;

  _BottomBarClipper(this.radius, this.curve);

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo((size.width * 0.5) - radius - (curve * 2), 0);
    path.arcToPoint(
      Offset((size.width * 0.5) - radius - curve, curve),
      clockwise: true,
      radius: Radius.circular(curve),
    );
    path.arcToPoint(
      Offset((size.width * 0.5) + radius + curve, curve),
      clockwise: false,
      radius: Radius.circular(radius),
    );
    path.arcToPoint(
      Offset((size.width * 0.5) + radius + (curve * 2), 0),
      clockwise: true,
      radius: Radius.circular(curve),
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CustomBottomBar extends ConsumerWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int activeIndex = ref.watch(pageIndexProvider);

    return SizedBox(
      height: 60.h,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: _BottomBarClipper(18.r, 10.r),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 100,
                      spreadRadius: 100,
                    ),
                  ],
                ),
                width: double.infinity,
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIcon(
                          active: activeIndex == 0,
                          icon: IconsaxPlusBroken.home,
                          activeIcon: IconsaxPlusBold.home,
                          label: "Home",
                          onTap: () =>
                              ref.watch(pageIndexProvider.notifier).state = 0,
                        ),
                        SizedBox(width: 30.w),
                        CustomIcon(
                          active: activeIndex == 1,
                          icon: IconsaxPlusBroken.gas_station,
                          activeIcon: IconsaxPlusBold.gas_station,
                          label: "Refill",
                          onTap: () =>
                              ref.watch(pageIndexProvider.notifier).state = 1,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIcon(
                          active: activeIndex == 2,
                          icon: IconsaxPlusBroken.devices,
                          activeIcon: IconsaxPlusBold.devices,
                          label: "Device",
                          onTap: () =>
                              ref.watch(pageIndexProvider.notifier).state = 2,
                        ),
                        SizedBox(width: 30.w),
                        CustomIcon(
                          active: activeIndex == 3,
                          icon: IconsaxPlusBroken.profile,
                          activeIcon: IconsaxPlusBold.profile,
                          label: "Profile",
                          onTap: () =>
                              ref.watch(pageIndexProvider.notifier).state = 3,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () => context.router.pushNamed(Pages.cheffy),
              child: Image.asset(
                "assets/images/Cheffy.gif",
                width: 40.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  final bool active;
  final String label;
  final IconData activeIcon;
  final IconData icon;
  final VoidCallback onTap;

  const CustomIcon({
    super.key,
    required this.active,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcherPlus.zoomOut(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              active ? activeIcon : icon,
              size: 22.r,
              key: ValueKey<bool>(active),
              color: active ? primary : neutral3,
            ),
          ),
          Text(
            label,
            style: context.textTheme.bodyMedium!.copyWith(
                color: active ? primary : neutral3,
                fontWeight: active ? FontWeight.w500 : FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
