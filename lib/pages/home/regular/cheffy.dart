import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';

class CheffyPage extends StatefulWidget {
  const CheffyPage({super.key});

  @override
  State<CheffyPage> createState() => _CheffyPageState();
}

class _CheffyPageState extends State<CheffyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Cheffy",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
