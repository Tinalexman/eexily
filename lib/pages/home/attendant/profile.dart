import 'package:cached_network_image/cached_network_image.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  late Color background, text;

  @override
  void initState() {
    super.initState();
    String name = ref.read(userProvider.select((value) => value.firstName));
    background = randomColor(name);
    text = chooseTextColor(background);
  }

  @override
  Widget build(BuildContext context) {
    Attendant attendant = ref.watch(userProvider) as Attendant;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: attendant.image,
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
            attendant.fullName,
            style: context.textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: monokai,
            ),
          ),
          Text(
            attendant.email,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: neutral2,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Phone: ${attendant.phoneNumber}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Location: ${attendant.location}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Gas Station Name: ${attendant.gasStationName}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            "Account Information",
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Account Name: ${attendant.accountName}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Bank Name: ${attendant.bankName}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Account Number: ${attendant.accountNumber}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
        ],
      ),
    );
  }
}
