import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../tools/appColors.dart';
import '../sized_box.dart';
import '../text_widget/text_widget.dart';

class OneButton extends StatelessWidget {
  final Color? color;
  final Color? labelColor;
  final Color? svgColor;
  final String? label;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? radius;
  final VoidCallback? onTap;
  final int? flexBt;
  final Widget? icon;
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
  bool progress = false;

  OneButton({
    super.key,
    this.color,
    this.label,
    this.width,
    this.onTap,
    this.flexBt,
    this.labelColor,
    this.fontSize,
    this.icon,
    this.iconOnTap,
    this.progress = false,
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
        height: height ?? 50,
        width: width ?? 170.w,
        decoration: BoxDecoration(
          color: color ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(radius ?? 8.r),
          border: Border.all(
            color: borderColor ?? AppColors.borderColor,
          ),
        ),
        child: progress
            ? const CircularProgressIndicator.adaptive()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Elementlarni markazga qarab boshlash

                  children: [
                    Visibility(
                      visible: isVisible ?? true,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            child: icon ?? const SizedBox(),
                          ),
                          const Wd(),
                        ],
                      ),
                    ),
                    TextWidget(
                      txt: label ?? "",
                      fontWeight: labelFontWight ?? FontWeight.w600,
                      size: fontSize ?? 14.sp,
                      elips: true,
                      txtColor: labelColor ?? Colors.white,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
