import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eexily/api/file_handler.dart';
import 'package:eexily/tools/constants.dart';

class ChooseDriverImage extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const ChooseDriverImage({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<ChooseDriverImage> createState() => _ChooseDriverImageState();
}

class _ChooseDriverImageState extends ConsumerState<ChooseDriverImage>
    with SingleTickerProviderStateMixin {


  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 22.w,
            vertical: 10.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Text(
                  "Eexily",
                  style: context.textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                Text(
                  "Upload your image",
                  style: context.textTheme.bodyLarge,
                ),
                SizedBox(height: 32.h),
                GestureDetector(
                  onTap: () async {
                    SingleFileResponse? response = await FileHandler.single(
                      type: FileType.image,
                    );

                    if(response != null) {
                      setState(() => image = response.data);
                    }
                  },
                  child: CircleAvatar(
                    radius: 120.r,
                    backgroundColor: image == null ? primary50 : null,
                    backgroundImage: image != null ? MemoryImage(image!) : null,
                    child: image == null
                        ? Icon(
                      Icons.image_outlined,
                      size: 48.r,
                      color: monokai,
                    )
                        : null,
                  ),
                ),

                SizedBox(
                  height: 220.h,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(390.w, 50.h),
                    backgroundColor: primary,
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5.r),
                    ),
                  ),
                  onPressed: () {
                    context.router.goNamed(Pages.login);
                  },
                  child: Text(
                    "Finish",
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
