import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/transaction.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const SpinKitFadingFour loader = SpinKitFadingFour(
  color: primary,
  size: 20,
);

const SpinKitFadingFour whiteLoader = SpinKitFadingFour(
  color: Colors.white,
  size: 20,
);

class TabHeaderDelegate extends SliverPersistentHeaderDelegate {
  TabHeaderDelegate({required this.tabBar});

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: context.isDark ? Colors.black : Colors.white,
        child: tabBar,
      );

  @override
  bool shouldRebuild(TabHeaderDelegate oldDelegate) => false;
}

class Popup extends StatelessWidget {
  const Popup({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: CenteredPopup(),
      );
}

class CenteredPopup extends StatelessWidget {
  const CenteredPopup({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: loader);
}

class SpecialForm extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final String? hint;
  final Color? fillColor;
  final Color? borderColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final bool obscure;
  final bool autoValidate;
  final FocusNode? focus;
  final bool autoFocus;
  final Function? onChange;
  final Function? onActionPressed;
  final Function? onValidate;
  final Function? onSave;
  final BorderRadius? radius;
  final TextEditingController controller;
  final TextInputType type;
  final TextInputAction action;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool readOnly;
  final int? maxLines;
  final bool allowHeightExpand;
  final double width;
  final double height;

  const SpecialForm({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
    this.fillColor,
    this.borderColor,
    this.textColor,
    this.padding,
    this.hintStyle,
    this.style,
    this.focus,
    this.autoFocus = false,
    this.readOnly = false,
    this.obscure = false,
    this.allowHeightExpand = false,
    this.autoValidate = false,
    this.type = TextInputType.text,
    this.action = TextInputAction.none,
    this.onActionPressed,
    this.onChange,
    this.onValidate,
    this.onSave,
    this.radius,
    this.hint,
    this.prefix,
    this.suffix,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    return SizedBox(
      width: width,
      height: allowHeightExpand ? null : height,
      child: TextFormField(
        autovalidateMode:
            autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        maxLines: maxLines,
        focusNode: focus,
        autofocus: autoFocus,
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        textInputAction: action,
        readOnly: readOnly,
        onEditingComplete: () {
          if (onActionPressed != null) {
            onActionPressed!(controller.text);
          }
        },
        cursorColor: primary,
        style: style ??
            context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
        decoration: InputDecoration(
          errorMaxLines: 1,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          fillColor: fillColor ?? (darkTheme ? monokai : Colors.white),
          filled: true,
          contentPadding: padding ??
              EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: maxLines == 1 ? 5.h : 10.h,
              ),
          prefixIcon: prefix != null
              ? SizedBox(
                  width: height,
                  height: height,
                  child: Center(
                    child: prefix,
                  ),
                )
              : null,
          suffixIcon: suffix != null
              ? SizedBox(
                  width: height,
                  height: height,
                  child: Center(child: suffix),
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: radius ?? BorderRadius.circular(7.5.r),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: radius ?? BorderRadius.circular(7.5.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: radius ?? BorderRadius.circular(7.5.r),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          hintStyle: hintStyle ??
              context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w300,
                color: darkTheme ? Colors.white38 : Colors.black45,
              ),
        ),
        onChanged: (value) {
          if (onChange == null) return;
          onChange!(value);
        },
        validator: (value) {
          if (onValidate == null) return null;
          return onValidate!(value);
        },
        onSaved: (value) {
          if (onSave == null) return;
          onSave!(value);
        },
      ),
    );
  }
}

class ComboBox extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;
  final bool noDecoration;

  const ComboBox({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.noDecoration = false,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Container(
          alignment: hintAlignment,
          child: Text(
            hint,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        value: value,
        items: dropdownItems
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Container(
                  alignment: valueAlignment,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: context.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        selectedItemBuilder: selectedItemBuilder,
        buttonStyleData: ButtonStyleData(
          height: (noDecoration) ? null : buttonHeight ?? 40,
          width: (noDecoration) ? 80 : buttonWidth ?? 140,
          padding: (noDecoration)
              ? null
              : buttonPadding ?? const EdgeInsets.only(left: 14, right: 14),
          decoration: (noDecoration)
              ? null
              : buttonDecoration ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      buttonHeight == null ? 20 : 7.5.r,
                    ),
                  ),
          elevation: buttonElevation,
        ),
        iconStyleData: IconStyleData(
          icon: icon ?? const Icon(Icons.arrow_forward_ios_outlined),
          iconSize: iconSize ?? 12,
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconDisabledColor,
        ),
        dropdownStyleData: DropdownStyleData(
          //Max height for the dropdown menu & becoming scrollable if there are more items. If you pass Null it will take max height possible for the items.
          maxHeight: dropdownHeight ?? 200,
          width: dropdownWidth ?? 140,
          padding: dropdownPadding,
          decoration: dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
          elevation: dropdownElevation ?? 8,
          //Null or Offset(0, 0) will open just under the button. You can edit as you want.
          offset: offset,
          scrollbarTheme: ScrollbarThemeData(
            radius: scrollbarRadius ?? const Radius.circular(40),
            thickness: scrollbarThickness != null
                ? MaterialStatePropertyAll(scrollbarThickness!)
                : null,
            thumbVisibility: scrollbarAlwaysShow != null
                ? MaterialStatePropertyAll(scrollbarAlwaysShow!)
                : null,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: itemHeight ?? 40,
          padding: itemPadding ?? const EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late int m, y;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    m = now.month;
    y = now.year;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      width: 375.w,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30.w,
          vertical: 15.h,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Month",
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Year",
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 170.h,
                  width: 100.w,
                  child: ListWheelScrollView(
                    itemExtent: 35.h,
                    physics: const BouncingScrollPhysics(),
                    onSelectedItemChanged: (val) => setState(() => m = val + 1),
                    children: List.generate(
                      12,
                      (index) => Text(
                        month((index + 1).toString(), false),
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: (m == index + 1)
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 170.h,
                  width: 80.w,
                  child: ListWheelScrollView(
                    itemExtent: 35.h,
                    physics: const BouncingScrollPhysics(),
                    onSelectedItemChanged: (index) => setState(() {
                      int calculatedYear = DateTime.now().year;
                      if (index <= 3) {
                        calculatedYear -= 4 - index;
                      } else if (index > 4) {
                        calculatedYear += index - 4;
                      }
                      y = calculatedYear;
                    }),
                    children: List.generate(
                      9,
                      (index) {
                        int calculatedYear = DateTime.now().year;
                        if (index <= 3) {
                          calculatedYear -= 4 - index;
                        } else if (index > 4) {
                          calculatedYear += index - 4;
                        }

                        return Text(
                          calculatedYear.toString(),
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                            fontWeight: (y == calculatedYear)
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                elevation: 1.0,
                fixedSize: Size(375.w, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5.r),
                ),
              ),
              onPressed: () => context.router.pop([m, y]),
              child: Text(
                "Confirm",
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget heroShuttleBuilder(
    BuildContext context,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromContext,
    BuildContext toContext) {
  switch (direction) {
    case HeroFlightDirection.push:
      return ScaleTransition(
        scale: animation.drive(
          Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).chain(
            CurveTween(curve: Curves.fastOutSlowIn),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: toContext.widget,
        ),
      );
    case HeroFlightDirection.pop:
      return fromContext.widget;
  }
}

class TransactionContainer extends StatelessWidget {
  final Transaction transaction;

  const TransactionContainer({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.5.r),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: primary50.withOpacity(0.6),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.r),
              child: Icon(
                transaction.credit
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 32.r,
                color: primary,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                transaction.header,
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: monokai,
                ),
              ),
              Text(
                formatDateRawWithTime(transaction.timestamp, shorten: true),
                style: context.textTheme.bodySmall,
              )
            ],
          ),
          Text(
            "${transaction.credit ? "+" : "-"}₦${formatAmount(transaction.amount.toStringAsFixed(0))}",
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: transaction.credit ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderContainer extends StatelessWidget {
  final String link;
  final Order order;

  const OrderContainer({
    super.key,
    required this.link,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.pushNamed(
        link,
        extra: order,
      ),
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 10.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.5.r),
                image: DecorationImage(
                  image: AssetImage(order.riderImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              order.riderName,
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: monokai,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Gas Ordered:",
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: monokai,
                  ),
                ),
                Text(
                  "₦${formatAmount(order.price.toStringAsFixed(0))}",
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: monokai,
                  ),
                )
              ],
            ),
            Text(
              "Rider",
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RiderOrderDetail extends StatelessWidget {
  final Order order;
  const RiderOrderDetail({super.key, required this.order,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rider",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80.h,
                width: 80.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.5.r),
                  image: DecorationImage(
                    image: AssetImage(order.riderImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    order.riderName,
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: monokai,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Vehicle Number: ${order.riderBike}",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: monokai,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
