import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseBusinessCategoryPage extends StatefulWidget {
  final String initial;

  const ChooseBusinessCategoryPage({
    super.key,
    required this.initial,
  });

  @override
  State<ChooseBusinessCategoryPage> createState() =>
      _ChooseBusinessCategoryPageState();
}

class _ChooseBusinessCategoryPageState
    extends State<ChooseBusinessCategoryPage> {
  final List<String> categories = [
    "Restaurant/Cafe",
    "Catering Service",
    "Hotel/Resort",
    "Food Truck",
    "Bakery/Pastry Shop",
    "Supermarket/Grocery Shop",
    "Bar/Club",
    "School/University Cafeteria",
    "Event Venue",
    "Hospital/Clinic",
    "Manufacturing Plant",
    "Construction Company",
    "Laundromat",
    "Office Building",
    "Shopping Mall",
    "Gas Station",
    "Agricultural Farm",
    "Pharmaceutical Company",
    "Government Agency",
    "Non-profit Organization",
    "Real Estate Management",
    "Religious Institution",
    "Beauty Salon/Barber Shop",
    "Fitness Center/Gym",
    "Logistics/Delivery Service",
    "IT/Data Center",
    "Media Production Studio",
    "Printing/Publishing House",
    "Auto Repair Shop",
    "Workshop/Artisan Hub",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 22.w,
            vertical: 10.h,
          ),
          child: ListView.separated(
            itemBuilder: (_, index) {
              if (index == categories.length) {
                return SizedBox(height: 20.h);
              }
              return ListTile(
                key: ValueKey<int>(index),
                onTap: () => context.router.pop(categories[index]),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5.r),
                ),
                title: Text(
                  categories[index],
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: widget.initial == categories[index] ? primary : null,
                  ),
                ),
                trailing: widget.initial == categories[index]
                    ? const Icon(
                        Icons.done_rounded,
                        color: primary,
                        size: 20,
                      )
                    : null,
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemCount: categories.length + 1,
            physics: const BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
