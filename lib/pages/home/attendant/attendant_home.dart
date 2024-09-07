import 'package:eexily/pages/home/attendant/home.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AttendantHome extends ConsumerStatefulWidget {
  const AttendantHome({super.key});

  @override
  ConsumerState<AttendantHome> createState() => _AttendantHomeState();
}

class _AttendantHomeState extends ConsumerState<AttendantHome> {
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

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: children,
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
              IconsaxPlusBroken.graph,
              size: 22.r,
            ),
            activeIcon: Icon(
              IconsaxPlusBold.graph,
              size: 22.r,
            ),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconsaxPlusBroken.chart_1,
              size: 22.r,
            ),
            activeIcon: Icon(
              IconsaxPlusBold.chart_1,
              size: 22.r,
            ),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
