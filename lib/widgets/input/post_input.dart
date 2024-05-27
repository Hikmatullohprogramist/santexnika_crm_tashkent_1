// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/tools/appColors.dart';

class PostInput extends StatelessWidget {
  final String? label;
  final String? hintText;
  final Color? color;
  final Color? txtColor;
  final String? image;
  final TextEditingController? controller;
  final double? height;
  final double? widht;
  final double? inputWidth;
  final double? inputHeight;
  final bool? visible;
  final Widget? prefixIcon;
  final VoidCallback?onTap;
  final Widget? suffixIcon;
  final double? sizeBox;
  final double? radius;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLenght;
  final String? TextLable;
  final VoidCallback? iconTap;
  final bool? readOnly;
  final Widget? stayle;
  final MainAxisAlignment? mainAxisAlignment;
  final Function(String)? onChanged;

  const PostInput({
    super.key,
    this.hintText,
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
    this.iconTap,
    this.readOnly,
    this.inputHeight,
    this.stayle,
    this.onChanged,
    this.visible,
    this.prefixIcon,
    this.txtColor,
    this.radius,
    this.mainAxisAlignment,
    this.suffixIcon, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        Visibility(
          visible: visible ?? true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label ?? "",
                style: TextStyle(
                  color: txtColor ?? Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 8.h,
              ),
            ],
          ),
        ),
        Container(
          height: inputHeight ?? 40,
          width: inputWidth ?? 300.w,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor, width: 1),
            borderRadius: BorderRadius.circular(radius??5),
          ),
          child: TextField(
            onChanged: onChanged,
            onTap: onTap,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 12.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            ),
            readOnly: readOnly ?? false,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatter,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius??5),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
              filled: true,
              fillColor: color ?? AppColors.primaryColor,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
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
