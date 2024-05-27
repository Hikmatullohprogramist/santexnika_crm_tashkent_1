import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerDataRowText extends StatelessWidget {
  final dynamic txt;
  final Color? txtColor;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final bool? elips;

  const CustomerDataRowText({
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
    return Tooltip(
      message: txt,
      child: Text(
        txt,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
