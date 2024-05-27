import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 
class DataColumnText extends StatelessWidget {
  final String txt;
  final Color? txtColor;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final bool? elips;

  const DataColumnText({
    super.key,
    required this.txt,
    this.txtColor,
    this.size,
    this.fontWeight,
    this.textAlign,
    this.elips,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        color: txtColor ?? Colors.white,
        fontSize: size ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.bold,
      ),
      overflow: elips == true ? TextOverflow.ellipsis : null,
    );
  }
}
