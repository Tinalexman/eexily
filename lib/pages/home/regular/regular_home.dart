import 'package:eexily/pages/refill/refill.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'drawer.dart';
import 'home.dart';

class RegularHome extends ConsumerStatefulWidget {
  const RegularHome({super.key});

  @override
  ConsumerState<RegularHome> createState() => _RegularHomeState();
}

class _RegularHomeState extends ConsumerState<RegularHome> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        return !context.router.canPop();
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: EexilyUserDrawer(
          onCloseDrawer: () => scaffoldKey.currentState?.closeDrawer(),
        ),
        body: Home(
          scaffoldKey: scaffoldKey,
        ),
        bottomNavigationBar: const CustomBottomBar(),
      ),
    );
  }
}
