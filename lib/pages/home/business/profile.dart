import 'package:cached_network_image/cached_network_image.dart';
import 'package:eexily/components/user/business.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    Business business = ref.watch(userProvider) as Business;
    int gasSize = ref.watch(gasCylinderSizeProvider);
    int gasPercentage = ref.watch(gasLevelProvider);
    bool active = ref.watch(playGasAnimationProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: business.image,
            errorWidget: (_, __, ___) => Container(
              width: 375.w,
              height: 250.h,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            progressIndicatorBuilder: (_, __, ___) => Container(
              width: 375.w,
              height: 250.h,
              decoration: BoxDecoration(
                color: primary50,
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            imageBuilder: (_, provider) => Container(
              width: 375.w,
              height: 250.h,
              decoration: BoxDecoration(
                color: primary50,
                borderRadius: BorderRadius.circular(15.r),
                image: DecorationImage(
                  image: provider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            business.fullName,
            style: context.textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: monokai,
            ),
          ),
          Text(
            business.email,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: neutral2,
            ),
          ),
          Text(
            business.phoneNumber,
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cylinder Size",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: monokai,
                ),
              ),
              Text(
                "${gasSize}kg",
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: monokai,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gas Level",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: monokai,
                ),
              ),
              Text(
                "$gasPercentage%",
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: gasColor(gasPercentage * 0.01),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gas Tracking",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: monokai,
                ),
              ),
              Text(
                active ? "Active" : "Inactive",
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: active ? primary : neutral3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
