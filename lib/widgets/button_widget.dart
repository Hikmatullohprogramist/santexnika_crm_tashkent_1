// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final Color? color;
  final Color? Labelcolor;
  final Color? svgColor;
  final String? label;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? radius;
  final VoidCallback? onTap;
  final int? flexBt;
  final IconData? icon;
  final VoidCallback? iconOnTap;
  final FontWeight? labelFontWight;
  final String? svgIcon;
  final double? svgWidth;
  final bool? isVisible;
  final bool? isVisibleIcon;
  final Color? borderColor;
  final Color? iconColor;
  final double? padding;
  final double? iconSize;

  const ButtonWidget({
    super.key,
    this.color,
    this.label,
    this.width,
    this.onTap,
    this.flexBt,
    this.Labelcolor,
    this.fontSize,
    this.icon,
    this.iconOnTap,
    this.labelFontWight,
    this.svgIcon,
    this.svgWidth,
    this.svgColor,
    this.iconColor,
    this.isVisible,
    this.height,
    this.borderColor,
    this.padding,
    this.radius,
    this.isVisibleIcon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 50.h,
        width: width ?? 400.w,
        decoration: BoxDecoration(
            color: color ?? AppColors.bottombarColor,
            borderRadius: BorderRadius.circular(radius ?? 8.r),
            border: Border.all(
              color: borderColor ?? AppColors.borderColor,
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),



          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isVisible ?? true,
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: iconColor ?? Colors.white,
                      size: iconSize ?? 18,
                    ),
                    Wd(),
                  ],
                ),
              ),
              TextWidget(
                txt: label ?? "",
                fontWeight: labelFontWight ?? FontWeight.w600,
                size: fontSize ?? 14.sp,
                elips: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
