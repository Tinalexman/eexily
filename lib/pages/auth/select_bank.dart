import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class SelectBankPage extends StatefulWidget {
  final String current;

  const SelectBankPage({
    super.key,
    required this.current,
  });

  @override
  State<SelectBankPage> createState() => _SelectBankPageState();
}

class _SelectBankPageState extends State<SelectBankPage> {
  final TextEditingController searchController = TextEditingController();
  late List<Map<String, dynamic>> filters;

  @override
  void initState() {
    super.initState();
    filters = List.from(bankCodes);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterBank(String text) {
    text = text.trim().toLowerCase();
    if(text.isEmpty) {
      filters = List.from(bankCodes);
      setState(() {});
      return;
    }

    filters.clear();
    for(Map<String, dynamic> map in bankCodes) {
      if((map["bank_name"] as String).toLowerCase().contains(text)) {
        filters.add(map);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Bank",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SpecialForm(
                controller: searchController,
                width: 375.w,
                fillColor: Colors.grey[200],
                hint: "Search banks",
                prefix: const Icon(
                  IconsaxPlusBroken.search_normal,
                  color: neutral2,
                ),
                onChange: filterBank,
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    if (index == filters.length) {
                      return SizedBox(height: 20.h);
                    }
                    return ListTile(
                      key: ValueKey<int>(index),
                      onTap: () => context.router.pop(filters[index]),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.5.r),
                      ),
                      title: Text(
                        filters[index]["bank_name"],
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: widget.current == filters[index]["bank_name"]
                              ? primary
                              : null,
                        ),
                      ),
                      trailing: widget.current == filters[index]["bank_name"]
                          ? const Icon(
                              Icons.done_rounded,
                              color: primary,
                              size: 20,
                            )
                          : null,
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemCount: filters.length + 1,
                  physics: const BouncingScrollPhysics(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
