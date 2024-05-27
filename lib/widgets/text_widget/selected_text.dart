import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../tools/appColors.dart';
import '../sized_box.dart';

class TextSelected extends StatelessWidget {
  final bool isSelected;
  final String txt;
  final VoidCallback? onTap;

  const TextSelected({
    super.key,
    required this.isSelected,
    required this.txt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          TextWidget(
            txt: txt,
            txtColor:
            isSelected ? AppColors.whiteColor : AppColors.toqPrimaryColor,
            fontWeight: FontWeight.w500,
            size: 14.sp,
          ),
          const Hg(),
          isSelected
              ? Container(
            height: 3.h,
            width: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.r),
                topLeft: Radius.circular(10.r),
              ),
              color: AppColors.whiteColor,
            ),
          )
              : const SizedBox(),
        ],
      ),
    );
  }
}
