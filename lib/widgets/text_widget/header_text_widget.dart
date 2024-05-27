import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class HeaderTextWidget extends StatelessWidget {
  final String first;
  final String second;
  final double? size;

  const HeaderTextWidget(
      {super.key, required this.first, required this.second, this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextWidget(
            txt: '$first ',
            size: size ?? 18.sp,
          ),
        ),
        Expanded(
          child: TextWidget(
            txt: '$second ',
            size: size ?? 18.sp,

          ),
        ),
      ],
    );
  }
}
