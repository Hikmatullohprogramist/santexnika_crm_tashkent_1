import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidgetLine extends StatelessWidget {
  final dynamic txt;
  final Color? txtColor;
  final double? size;
  final VoidCallback? onTap;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final bool? elips;

  const TextWidgetLine({
    super.key,
    required this.txt,
    this.txtColor,
    this.size,
    this.fontWeight,
    this.textAlign,
    this.onTap,
    this.elips,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        txt,
        style: TextStyle(
          color: txtColor ?? Colors.white,
          fontSize: size ?? 12.sp,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
        overflow: elips == true ? TextOverflow.ellipsis : null,
      ),
    );
  }
}
