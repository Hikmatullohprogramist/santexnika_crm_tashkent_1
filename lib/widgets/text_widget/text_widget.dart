import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  final dynamic txt;
  final Color? txtColor;
  final double? size;
  final VoidCallback? onTap;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final bool? elips;
  final int? maxLines;

  const TextWidget({
    super.key,
    required this.txt,
    this.txtColor,
    this.size,
    this.fontWeight,
    this.textAlign,
    this.onTap,
    this.elips, this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        txt,
        style: TextStyle(
          color: txtColor ?? Colors.white,
          fontSize: size ?? 18.sp,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
        maxLines:maxLines?? 2,
        overflow: elips == true ? TextOverflow.ellipsis : null,
      ),
    );
  }
}
