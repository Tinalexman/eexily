import "package:curved_labeled_navigation_bar/curved_navigation_bar.dart";
import "package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart";
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'home.dart';

class RegularHome extends ConsumerStatefulWidget {
  const RegularHome({super.key});

  @override
  ConsumerState<RegularHome> createState() => _RegularHomeState();
}

class _RegularHomeState extends ConsumerState<RegularHome> {
  late List<Widget> children;

  @override
  void initState() {
    super.initState();
    children = const [
      Home(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    int index = ref.watch(pageIndexProvider);
    User user = ref.watch(userProvider) as User;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: AssetImage(user.image),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${user.firstName}",
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Welcome back",
                  style: context.textTheme.bodySmall,
                ),
              ],
            )
          ],
        ),
        actions: [
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
        child: IndexedStack(
          index: index,
          children: children,
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: index,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeOut,
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              index != 0 ? IconsaxPlusBroken.home : IconsaxPlusBold.home,
              color: index == 0 ? primary : null,
            ),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              index != 1 ? IconsaxPlusBroken.gas_station : IconsaxPlusBold.gas_station,
              color: index == 1 ? primary : null,
            ),
            label: 'Refill Gas',
          ),
          const CurvedNavigationBarItem(
            child: Icon(IconsaxPlusBroken.cup,
              color: null,
            ),
            label: '',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              index != 2 ? IconsaxPlusBroken.devices : IconsaxPlusBold.devices,
              color: index == 2 ? primary : null,
            ),
            label: 'Device',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              index != 3 ? IconsaxPlusBroken.profile : IconsaxPlusBold.profile,
              color: index == 3 ? primary : null,
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          ref.watch(pageIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
