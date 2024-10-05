import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndividualProfilePage extends ConsumerStatefulWidget {
  const IndividualProfilePage({super.key});

  @override
  ConsumerState<IndividualProfilePage> createState() => _IndividualProfilePageState();
}

class _IndividualProfilePageState extends ConsumerState<IndividualProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Profile",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
