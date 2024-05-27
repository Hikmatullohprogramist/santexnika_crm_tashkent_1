// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../tools/appColors.dart';

class LoginInput extends StatelessWidget {
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Color? color;
  final IconData? suffixIcon;
  final String? image;
  final TextEditingController? controller;
  final double? height;
  final double? widht;
  final double? inputWidth;
  final double? inputHeight;

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

  const LoginInput({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label ?? '',
              style: TextStyle(
                color: color ?? AppColors.primaryColor,
                fontSize: 18.84,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: inputWidth ?? 416.w,
          height: inputHeight ?? 40,
          decoration: ShapeDecoration(
            color: const Color(0xFFF5F7F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
          ),
          child: TextField(
            onChanged: onChanged,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 12.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
            ),
            readOnly: readOnly ?? false,
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLenght,
            inputFormatters: inputFormatter,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 12.sp,
              ),
              border: InputBorder.none,
              suffixIcon: InkWell(onTap: iconTap, child: Icon(suffixIcon)),
              prefixIcon: Icon(prefixIcon),
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
