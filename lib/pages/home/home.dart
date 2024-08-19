import 'package:eexily/components/user/base.dart';
import 'package:eexily/pages/home/attendant/attendant_home.dart';
import 'package:eexily/pages/home/driver/driver_home.dart';
import 'package:eexily/pages/home/premium/premium_home.dart';
import 'package:eexily/pages/home/regular/regular_home.dart';
import 'package:eexily/pages/home/support/support_home.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  Widget build(BuildContext context) {
    UserRole role = ref.watch(userProvider.select((u) => u.role));

    switch (role) {
      case UserRole.regular:
        return const RegularHome();
      case UserRole.premium:
        return const PremiumHome();
      case UserRole.attendant:
        return const AttendantHome();
      case UserRole.support:
        return const SupportHome();
      case UserRole.driver:
        return const DriverHome();
      default:
        return const SizedBox();
    }
  }
}
