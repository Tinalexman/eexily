import 'package:eexily/pages/home/common/drawer.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'home.dart';
import 'profile.dart';
import 'store.dart';

class MerchantHome extends ConsumerStatefulWidget {
  const MerchantHome({super.key});

  @override
  ConsumerState<MerchantHome> createState() => _MerchantHomeState();
}

class _MerchantHomeState extends ConsumerState<MerchantHome> {
  late List<Widget> children;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    children = const [
      Home(),
      Store(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                IconsaxPlusBroken.shop,
                size: 22.r,
              ),
              activeIcon: Icon(
                IconsaxPlusBold.shop,
                size: 22.r,
              ),
              label: "Store",
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
