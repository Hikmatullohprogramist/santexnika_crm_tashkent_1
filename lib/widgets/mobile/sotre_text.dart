
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../text_widget/text_widget.dart';

class StoreTextWidget extends StatelessWidget {
  final String txt;
  final double? size;
  final Color?color;
  const StoreTextWidget({super.key, required this.txt, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return TextWidget(
      txt:  txt,
      size: size??16.sp,
      elips: true,
      fontWeight: FontWeight.w400,
      txtColor:color?? Colors.white,
    );
  }
}
