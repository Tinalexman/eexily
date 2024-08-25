import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _Item {
  final String image;
  final String name;
  final String description;

  const _Item({
    this.image = "",
    this.name = "",
    this.description = "",
  });
}

class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key});

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  final PageController controller = PageController();
  int page = 0;

  final List<_Item> items = const [
    _Item(
        image: "assets/images/Rider.png",
        name: "Welcome to Eexily!",
        description:
            "Hi there! Ready to simplify your gas management? We’re here to save you time,money and effort. Let’s dive in!"),
    _Item(
        image: "assets/images/PhoneChart.png",
        name: "Smart Monitoring",
        description:
            "Stay updated on your gas levels effortlessly. Our app shows real-time data, so you always know how much is left."),
    _Item(
        image: "assets/images/YoungGirl.png",
        name: "Easy Ordering",
        description:
            "Running low? Just tap to order and relax. We’ll bring the gas right to your door-quick and easy!")
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          if (page != items.length - 1)
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: GestureDetector(
                onTap: () => controller.animateToPage(
                  items.length - 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                ),
                child: Text(
                  "Skip",
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            children: [
              SizedBox(height: 100.h),
              SizedBox(
                width: 375.h,
                height: 390.h,
                child: PageView.builder(
                  controller: controller,
                  itemBuilder: (_, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        items[index].image,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 50.h),
                      Text(
                        items[index].name,
                        style: context.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        items[index].description,
                        style: context.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  itemCount: items.length,
                  onPageChanged: (pg) => setState(() => page = pg),
                  physics: const BouncingScrollPhysics(),
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: 55.r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    items.length,
                    (index) => Container(
                      width: index == page ? 15.r : 12.r,
                      height: index == page ? 15.r : 12.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            index == page ? primary : const Color(0xFFD9D9D9),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(page != items.length - 1 ? 100.w : 375.w, 50.h),
                    fixedSize: Size(page != items.length - 1 ? 100.w : 375.w, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5.r),
                    ),
                    elevation: 1.0,
                    backgroundColor: primary,
                  ),
                  onPressed: () {
                    if (page != items.length - 1) {
                      controller.animateToPage(
                        page + 1,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOut,
                      );
                    } else {
                      context.router.pushReplacementNamed(Pages.onboard);
                    }
                  },
                  child: Text(
                    page == items.length - 1 ? "Continue" : "Next",
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
