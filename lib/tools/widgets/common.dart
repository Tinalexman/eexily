import 'dart:math';
import'dart:developer' as d;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eexily/api/refill.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/transaction.dart';
import 'package:eexily/components/user/base.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

const SpinKitThreeBounce loader = SpinKitThreeBounce(
  color: primary,
  size: 20,
);

const SpinKitThreeBounce whiteLoader = SpinKitThreeBounce(
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

class DigitGroupFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return newValue;
    }

    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    final formatter = NumberFormat('#,###');
    String formattedText = formatter.format(int.parse(newText));

    int selectionIndex =
        formattedText.length - (newValue.text.length - newValue.selection.end);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class CustomDigitGroupFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return newValue;
    }

    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    String formattedText = _groupDigits(newText);

    int selectionIndex =
        formattedText.length - (newValue.text.length - newValue.selection.end);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  String _groupDigits(String text) {
    if (text.length <= 3) {
      return text;
    }

    String firstGroup = text.substring(0, 3);

    List<String> groups = [];
    for (var i = 3; i < text.length; i += 4) {
      groups.add(text.substring(i, min(i + 4, text.length)));
    }

    return '$firstGroup ${groups.join(' ')}';
  }
}

class FourDigitGroupFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');

    StringBuffer formattedText = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText.write(' ');
      }
      formattedText.write(newText[i]);
    }

    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
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
  final List<TextInputFormatter>? formatters;

  const SpecialForm({
    super.key,
    required this.controller,
    required this.width,
    this.fillColor,
    this.formatters,
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
      child: TextFormField(
        autovalidateMode:
            autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        maxLines: maxLines,
        focusNode: focus,
        autofocus: autoFocus,
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        inputFormatters: formatters,
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
          errorStyle: context.textTheme.bodySmall!.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w300,
          ),
          fillColor: fillColor ?? Colors.white,
          filled: true,
          contentPadding: padding ??
              EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: maxLines == 1 ? 5.h : 10.h,
              ),
          prefixIcon: prefix != null
              ? SizedBox(
                  width: kMinInteractiveDimension,
                  height: kMinInteractiveDimension,
                  child: Center(
                    child: prefix,
                  ),
                )
              : null,
          suffixIcon: suffix != null
              ? SizedBox(
                  width: kMinInteractiveDimension,
                  height: kMinInteractiveDimension,
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
                color: Colors.black45,
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
              fontWeight: FontWeight.w300,
              color: Colors.black45,
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
          height:
              (noDecoration) ? null : buttonHeight ?? kMinInteractiveDimension,
          width: (noDecoration) ? 80 : buttonWidth ?? 375.w,
          padding: (noDecoration)
              ? null
              : buttonPadding ?? const EdgeInsets.symmetric(horizontal: 14),
          decoration: (noDecoration)
              ? null
              : buttonDecoration ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      7.5.r,
                    ),
                    color: Colors.white,
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
          maxHeight: dropdownHeight ?? 250,
          width: dropdownWidth ?? 140,
          padding: dropdownPadding,
          decoration: dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),
          elevation: dropdownElevation ?? 1,
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
            begin: 1.0,
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
            CachedNetworkImage(
              imageUrl: getUniqueImageUrl(order.metadata.riderName),
              errorWidget: (_, __, ___) {
                return Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5.r),
                    color: Colors.redAccent,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    IconsaxPlusBold.gallery_slash,
                    size: 32.r,
                    color: Colors.white,
                  ),
                );
              },
              progressIndicatorBuilder: (_, __, ___) {
                return Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5.r),
                    color: Colors.redAccent,
                  ),
                  alignment: Alignment.center,
                  child: loader,
                );
              },
              imageBuilder: (_, provider) {
                return Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5.r),
                    image: DecorationImage(
                      image: provider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            Text(
              order.metadata.riderName,
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

class GasOrderDetail extends StatelessWidget {
  final Order order;

  const GasOrderDetail({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      width: 375.w,
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
          Text(
            "Code #${order.code}",
            style: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: monokai,
            ),
          ),
          Text(
            order.status.capitalize,
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: primary,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                "assets/images/Two Cylinders.png",
                width: 120.w,
                height: 180.h,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: Container(
                  width: 180.w,
                  decoration: BoxDecoration(
                    color: primary50.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(7.5.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Price:",
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: monokai,
                            ),
                          ),
                          Text(
                            "₦${formatAmount(order.price.toStringAsFixed(0))}",
                            style: context.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: monokai,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Quantity:",
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: monokai,
                            ),
                          ),
                          Text(
                            "${order.quantity}kg",
                            style: context.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: monokai,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RiderOrderDetail extends StatelessWidget {
  final Order order;

  const RiderOrderDetail({
    super.key,
    required this.order,
  });

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
            "Rider/Driver",
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
              CachedNetworkImage(
                imageUrl: getUniqueImageUrl(order.metadata.riderName),
                errorWidget: (_, __, ___) {
                  return Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5.r),
                      color: Colors.redAccent,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      IconsaxPlusBold.gallery_slash,
                      size: 32.r,
                      color: Colors.white,
                    ),
                  );
                },
                progressIndicatorBuilder: (_, __, ___) {
                  return Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5.r),
                      color: primary50,
                    ),
                    alignment: Alignment.center,
                    child: loader,
                  );
                },
                imageBuilder: (_, provider) {
                  return Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5.r),
                      color: primary50.withOpacity(0.5),
                      image: DecorationImage(
                        image: provider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    order.metadata.riderName,
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: monokai,
                    ),
                  ),
                  SizedBox(
                    width: 210.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Phone: ${order.metadata.riderPhoneNumber}",
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: monokai,
                          ),
                        ),
                        IconButton(
                          onPressed: () => launchPhoneNumber(
                              order.metadata.riderPhoneNumber),
                          icon: const Icon(
                            Icons.phone,
                            color: primary,
                          ),
                          iconSize: 16.r,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
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

class UserOrderDetail extends StatelessWidget {
  final Order order;

  const UserOrderDetail({
    super.key,
    required this.order,
  });

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
            "Individual",
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
              CachedNetworkImage(
                imageUrl: getUniqueImageUrl(order.metadata.userName),
                errorWidget: (_, __, ___) {
                  return Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5.r),
                      color: Colors.redAccent,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      IconsaxPlusBold.gallery_slash,
                      size: 32.r,
                      color: Colors.white,
                    ),
                  );
                },
                progressIndicatorBuilder: (_, __, ___) {
                  return Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5.r),
                      color: primary50,
                    ),
                    alignment: Alignment.center,
                    child: loader,
                  );
                },
                imageBuilder: (_, provider) {
                  return Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5.r),
                      color: primary50.withOpacity(0.5),
                      image: DecorationImage(
                        image: provider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    order.metadata.userName,
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: monokai,
                    ),
                  ),
                  SizedBox(
                    width: 210.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Phone: ${order.metadata.userPhoneNumber}",
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: monokai,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              launchPhoneNumber(order.metadata.userPhoneNumber),
                          icon: const Icon(
                            Icons.phone,
                            color: primary,
                          ),
                          iconSize: 16.r,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 210.w,
                    child: Text(
                      "${order.metadata.pickUpAddress}, ${order.metadata.pickUpLocation}",
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: monokai,
                        fontWeight: FontWeight.w500,
                      ),
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

class MerchantOrderDetail extends StatelessWidget {
  final Order order;

  const MerchantOrderDetail({
    super.key,
    required this.order,
  });

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
            "Merchant",
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
              CachedNetworkImage(
                imageUrl: getUniqueImageUrl(order.metadata.merchantName),
                errorWidget: (_, __, ___) {
                  return Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5.r),
                      color: Colors.redAccent,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      IconsaxPlusBold.gallery_slash,
                      size: 32.r,
                      color: Colors.white,
                    ),
                  );
                },
                progressIndicatorBuilder: (_, __, ___) {
                  return Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5.r),
                      color: primary50,
                    ),
                    alignment: Alignment.center,
                    child: loader,
                  );
                },
                imageBuilder: (_, provider) {
                  return Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5.r),
                      color: primary50.withOpacity(0.5),
                      image: DecorationImage(
                        image: provider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    order.metadata.merchantName,
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: monokai,
                    ),
                  ),
                  SizedBox(
                    width: 210.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Phone: ${order.metadata.merchantPhoneNumber}",
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: monokai,
                          ),
                        ),
                        IconButton(
                          onPressed: () => launchPhoneNumber(
                              order.metadata.merchantPhoneNumber),
                          icon: const Icon(
                            Icons.phone,
                            color: primary,
                          ),
                          iconSize: 16.r,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 210.w,
                    child: Text(
                      "${order.metadata.merchantAddress}, ${order.metadata.merchantLocation}",
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: monokai,
                        fontWeight: FontWeight.w500,
                      ),
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

class UserGasStatistics extends ConsumerStatefulWidget {
  final bool hasCompleted;

  const UserGasStatistics({
    super.key,
    required this.hasCompleted,
  });

  @override
  ConsumerState<UserGasStatistics> createState() => _UserGasStatisticsState();
}

class _UserGasStatisticsState extends ConsumerState<UserGasStatistics> {
  DateTime? likelyRunningOutDate;

  @override
  void initState() {
    super.initState();
    String? endingDate = ref.read(gasEndingDateProvider);
    if (endingDate != null) {
      likelyRunningOutDate = DateTime.parse(endingDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    int level = ref.watch(gasLevelProvider);
    int cylinderSize = ref.watch(gasCylinderSizeProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
        child: SizedBox(
          width: 375.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Gas Usage",
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              (level * 0.01 * cylinderSize).toStringAsFixed(1),
                          style: context.textTheme.displaySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: "/${cylinderSize}kg",
                          style: context.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Gas level",
                        style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "$level%",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 5.h),
              SizedBox(
                width: 375.w,
                child: LinearProgressIndicator(
                  value: level * 0.01,
                  color: gasColor(level * 0.01),
                  backgroundColor: primary50.withOpacity(0.25),
                  minHeight: 25.h,
                  borderRadius: BorderRadius.circular(7.5.h),
                ),
              ),
              SizedBox(height: 10.h),
              if (widget.hasCompleted && likelyRunningOutDate != null)
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Likely running out on ",
                        style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text:
                            formatDateRaw(likelyRunningOutDate!, shorten: true),
                        style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessModal extends StatelessWidget {
  final String text;
  final VoidCallback onDismiss;

  const SuccessModal({
    super.key,
    required this.text,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      elevation: 0.0,
      child: Container(
        width: 300.w,
        height: 250.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 5.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/success.png",
              fit: BoxFit.cover,
              width: 120.w,
            ),
            Text(
              text,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                minimumSize: Size(220.w, 40.h),
                fixedSize: Size(220.w, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5.r),
                ),
              ),
              child: Text(
                "Continue",
                style: context.textTheme.bodySmall!.copyWith(
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

class CustomOrderStepper extends ConsumerStatefulWidget {
  final Order widgetOrder;
  final Function(Order) onUpdateState;

  const CustomOrderStepper({
    super.key,
    required this.widgetOrder,
    required this.onUpdateState,
  });

  @override
  ConsumerState<CustomOrderStepper> createState() => _CustomOrderStepperState();
}

class _CustomOrderStepperState extends ConsumerState<CustomOrderStepper> {
  late int total;

  late Widget completedStepIcon,
      nextStepToBeCompletedIcon,
      notCompletedStepIcon;

  late bool isDriver,
      isStation,
      isMerchant,
      isUser,
      canPay,
      canPickUp,
      canRefill,
      canDeliver;

  bool loading = false;

  late Order order;

  @override
  void initState() {
    super.initState();
    total = OrderState.values.length - 2;
    completedStepIcon = Center(
      child: Icon(
        Icons.done,
        size: 26.r,
        color: Colors.white,
      ),
    );

    nextStepToBeCompletedIcon = Center(
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: Colors.white,
        child: Center(
          child: CircleAvatar(
            radius: 5.r,
            backgroundColor: primary,
          ),
        ),
      ),
    );

    notCompletedStepIcon = Center(
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: Colors.white,
      ),
    );

    order = widget.widgetOrder;
    determineFlags();
  }

  void determineFlags() {
    UserBase base = ref.read(userProvider);
    isMerchant = base.role == UserRole.merchant;
    isStation = base.role == UserRole.attendant;
    isDriver = base.role == UserRole.driver;
    isUser = base.role == UserRole.individual;
    canPay = isUser && order.status == "MATCHED";
    canPickUp = isDriver && order.status == "PAID";
    canRefill = (isMerchant || isStation) && order.status == "PICK_UP";
    canDeliver = isDriver && order.status == "REFILL";
  }

  String getOrderTitle(int index) {
    switch (index) {
      case 0:
        return "Pending";
      case 1:
        return "Matched";
      case 2:
        return "Paid";
      case 3:
        return "Picked Up";
      case 4:
        return "Refilled";
      case 5:
        return "Delivered";
      default:
        return "";
    }
  }

  String getOrderSubtitle(int index) {
    switch (index) {
      case 0:
        return "The request is pending!";
      case 1:
        return "The request has been matched!";
      case 2:
        return "The payment has been confirmed!";
      case 3:
        return "The gas cylinder has been picked up!";
      case 4:
        return "The gas cylinder has been refilled!";
      case 5:
        return "The gas cylinder has been delivered!";
      default:
        return "";
    }
  }

  void showMessage(String message, [Color? color]) =>
      showToast(message, context, backgroundColor: color);

  Future<void> updateStatus(String status) async {
    setState(() => loading = true);
    var response = await updateOrderStatus(status, order.code);
    setState(() => loading = false);
    showMessage(response.message, response.status ? primary : null);
    if (response.status) {
      widget.onUpdateState(response.payload!);
      setState(() {
        order = response.payload!;
        determineFlags();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: total,
      itemBuilder: (_, index) {
        bool hasStepBeingCompleted = index < order.states.length;
        bool isNextToBeCompleted = index == order.states.length;
        bool isLastStep = index == total - 1;
        DateTime? stepTimestamp;
        if (index < order.states.length) {
          stepTimestamp = DateTime.parse(order.states[index].timestamp);
        }

        return SizedBox(
          width: 375.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: primary,
                    child: hasStepBeingCompleted
                        ? completedStepIcon
                        : isNextToBeCompleted
                            ? nextStepToBeCompletedIcon
                            : notCompletedStepIcon,
                  ),
                  if (!isLastStep)
                    Container(
                      width: 2.w,
                      height: 60.r,
                      color: primary50,
                    )
                ],
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getOrderTitle(index),
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    getOrderSubtitle(index),
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (canPay && index == 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              launchPayStackUrl(order.paymentUrl),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.5.r),
                            ),
                            elevation: 1.0,
                            fixedSize: Size(120.w, 40.h),
                          ),
                          child: Text(
                            "Pay Now",
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        ElevatedButton(
                          onPressed: () => updateStatus("CANCELED"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.5.r),
                            ),
                            side: const BorderSide(color: Colors.redAccent),
                            elevation: 1.0,
                            fixedSize: Size(140.w, 40.h),
                          ),
                          child: loading
                              ? loader
                              : Text(
                                  "Cancel Order",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  if (canPickUp && index == 3)
                    ElevatedButton(
                      onPressed: () => updateStatus("PICK_UP"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.5.r),
                        ),
                        elevation: 1.0,
                        fixedSize: Size(120.w, 40.h),
                      ),
                      child: loading
                          ? whiteLoader
                          : Text(
                              "Picked Up",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  if (canRefill && index == 4)
                    ElevatedButton(
                      onPressed: () => updateStatus("REFILL"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.5.r),
                        ),
                        elevation: 1.0,
                        fixedSize: Size(120.w, 40.h),
                      ),
                      child: loading
                          ? whiteLoader
                          : Text(
                              "Refilled",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  if (canDeliver && index == 5)
                    ElevatedButton(
                      onPressed: () => updateStatus("DELIVERED"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.5.r),
                        ),
                        elevation: 1.0,
                        fixedSize: Size(120.w, 40.h),
                      ),
                      child: loading
                          ? whiteLoader
                          : Text(
                              "Delivered",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  if (stepTimestamp != null)
                    Text(
                      formatDateRawWithTime(stepTimestamp),
                      style: context.textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class NonUserOrderContainer extends StatefulWidget {
  final Order order;
  final String destination;

  const NonUserOrderContainer({
    super.key,
    required this.destination,
    required this.order,
  });

  @override
  State<NonUserOrderContainer> createState() => _NonUserOrderContainerState();
}

class _NonUserOrderContainerState extends State<NonUserOrderContainer> {
  late Color background, text;

  @override
  void initState() {
    super.initState();
    background = randomColor(widget.order.metadata.userName);
    text = chooseTextColor(background);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.pushNamed(
        widget.destination,
        extra: widget.order,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: getUniqueImageUrl(widget.order.metadata.userName),
              errorWidget: (_, __, ___) {
                return CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.redAccent,
                  child: Icon(
                    IconsaxPlusBold.gallery_slash,
                    size: 32.r,
                    color: Colors.white,
                  ),
                );
              },
              progressIndicatorBuilder: (_, __, ___) {
                return CircleAvatar(
                  radius: 24.r,
                  backgroundColor: primary50,
                );
              },
              imageBuilder: (_, provider) {
                return CircleAvatar(
                  radius: 24.r,
                  backgroundColor: primary50.withOpacity(0.5),
                  backgroundImage: provider,
                );
              },
            ),
            SizedBox(
              height: 48.r,
              width: 200.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.order.metadata.userName,
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: monokai,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "G-Code: ${widget.order.code}",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: background,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48.r,
              width: 60.r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${widget.order.quantity}kg",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: monokai,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    convertTime(DateTime.parse(widget.order.createdAt)),
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: monokai,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
