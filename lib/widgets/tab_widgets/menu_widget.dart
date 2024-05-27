// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../tools/appColors.dart';
import '../sized_box.dart';

class TabMenuWidget extends StatelessWidget {
  final Widget? svgIcon;
  final String? txt;
  final Color? colorIcon;
  final Color? txtColor;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isVisible;

  const TabMenuWidget(
      {super.key,
      this.svgIcon,
      this.txt,
      this.colorIcon,
      this.txtColor,
      this.onTap,
      required this.isSelected, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isSelected
                ? Container(
                    width: 5.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(17.r),
                        bottomRight: Radius.circular(17.r),
                      ),
                      color: AppColors.selectedColor,
                    ),
                  )
                : const SizedBox(),
            Wd(
              width: isSelected ? 25.w : 30.w,
            ),
            Row(
              children: [
                svgIcon??const SizedBox(),
                const Wd(),
                Text(
                  txt ?? '',
                  style: TextStyle(
                    color: isSelected ? AppColors.selectedColor : Colors.grey,
                    fontSize: 20.sp
                  ),
                ),
              ],
            ),
            Hg(
              height: 50.h,
            )
          ],
        ),
      ),
    );
  }
}
