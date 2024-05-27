import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../tools/appColors.dart';

class CommentInput extends StatelessWidget {
  final String? label;
  final String? hintText;
  final Widget? prefix;
  final Color? color;
  final Color? txtColor;
  final Widget? suffix;
  final String? image;
  final TextEditingController? controller;
  final double? height;
  final double? widht;
  final double? inputWidth;
  final double? inputHeight;
  final double? radius;
  final bool? visible;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? sizeBox;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLenght;
  final String? TextLable;
  final bool? isVisible;
  final VoidCallback? iconTap;
  final bool? readOnly;
  final Widget? stayle;
  final Function(String)? onChanged;

  const CommentInput({
    super.key,
    this.hintText,
    this.prefix,
    this.suffix,
    this.controller,
    this.label,
    this.height,
    this.widht,
    this.inputWidth,
    this.image,
    this.sizeBox,
    this.color,
    this.keyboardType,
    this.inputFormatter,
    this.maxLenght,
    this.TextLable,
    this.isVisible,
    this.iconTap,
    this.readOnly,
    this.inputHeight,
    this.stayle,
    this.onChanged,
    this.visible,
    this.prefixIcon,
    this.txtColor,
    this.radius,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: visible ?? true,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    label ?? "",
                    style: TextStyle(
                      color: txtColor ?? Colors.black,
                      fontSize: 14.sp,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
        Container(
          height: inputHeight ?? 100.spMax,
          width: inputWidth ?? 300.w,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(radius ?? 10.r),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1.w,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: TextField(
              onChanged: onChanged,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
              ),
              readOnly: readOnly ?? false,
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLenght,
              maxLines: null,
              inputFormatters: inputFormatter,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppColors.bottombarColor,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                suffix: suffix,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                prefix: prefix,
              ),
            ),
          ),
        ),
        SizedBox(
          height: height,
          width: widht,
        )
      ],
    );
  }
}
