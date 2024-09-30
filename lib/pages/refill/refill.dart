import 'package:eexily/components/user/base.dart';
import 'package:eexily/pages/home/attendant/attendant_home.dart';
import 'package:eexily/pages/home/driver/driver_home.dart';
import 'package:eexily/pages/home/regular/regular_home.dart';
import 'package:eexily/pages/home/support/support_home.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RefillPage extends StatefulWidget {
  const RefillPage({super.key});

  @override
  State<RefillPage> createState() => _RefillPageState();
}

class _RefillPageState extends State<RefillPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Refill",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),

                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
