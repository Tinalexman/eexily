import 'package:cached_network_image/cached_network_image.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/pages/home/common/drawer.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'home.dart';
import 'profile.dart';

class AttendantHome extends ConsumerStatefulWidget {
  const AttendantHome({super.key});

  @override
  ConsumerState<AttendantHome> createState() => _AttendantHomeState();
}

class _AttendantHomeState extends ConsumerState<AttendantHome> {
  late List<Widget> children;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    children = const [
      Home(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Attendant attendant = ref.watch(userProvider) as Attendant;
    int index = ref.watch(pageIndexProvider);

    return BackButtonListener(
      onBackButtonPressed: () async {
        final canPop = context.router.canPop();
        if (!canPop) {
          ref.watch(pageIndexProvider.notifier).state = 0;
        }
        return !canPop;
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: EexilyUserDrawer(
          onCloseDrawer: () => scaffoldKey.currentState?.closeDrawer(),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: index == 0
              ? GestureDetector(
                  onTap: () => scaffoldKey.currentState?.openDrawer(),
                  child: Icon(
                    IconsaxPlusBroken.menu_1,
                    size: 26.r,
                  ),
                )
              : Text(
                  "Profile",
                  style: context.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
          actions: [
            if (index == 0)
              GestureDetector(
                onTap: () => ref.watch(pageIndexProvider.notifier).state = 1,
                child: CachedNetworkImage(
                  imageUrl: attendant.image,
                  errorWidget: (_, __, ___) => CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Colors.redAccent,
                    child: Center(
                      child: Icon(
                        IconsaxPlusBold.gallery_slash,
                        color: Colors.white,
                        size: 20.r,
                      ),
                    ),
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
              onPressed: () {
                if (index == 0) {
                  context.router.pushNamed(Pages.notification);
                } else if (index == 1) {
                  context.router.pushNamed(Pages.editAttendantProfile);
                }
              },
              icon: Icon(
                index == 0
                    ? IconsaxPlusBroken.notification_1
                    : IconsaxPlusBroken.edit_2,
                color: monokai,
              ),
              iconSize: 26.r,
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            child: IndexedStack(
              index: index,
              children: children,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: primary,
          unselectedItemColor: neutral3,
          onTap: (val) => ref.watch(pageIndexProvider.notifier).state = val,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxPlusBroken.menu,
                size: 22.r,
              ),
              activeIcon: Icon(
                IconsaxPlusBold.menu,
                size: 22.r,
              ),
              label: "Overview",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxPlusBroken.profile,
                size: 22.r,
              ),
              activeIcon: Icon(
                IconsaxPlusBold.profile,
                size: 22.r,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
