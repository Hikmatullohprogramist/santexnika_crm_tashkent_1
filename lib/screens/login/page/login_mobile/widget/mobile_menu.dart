import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../tools/appColors.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/text_widget.dart';

class MobileMenuWidget extends StatelessWidget {
  final Widget? icon;
  final String? txt;
  final VoidCallback onTap;
  final bool? visible;
  const MobileMenuWidget({super.key, this.icon, this.txt, required this.onTap, this.visible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible??true,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              width: 368.w,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.76),
                color: AppColors.whiteColor,
                border: Border.all(
                  color: AppColors.whiteColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(5.76),
                        bottomLeft: Radius.circular(5.76),
                      ),
                      border: Border.all(color: AppColors.borderColor),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1,
                          color: AppColors.primaryColor,
                        )
                      ],
                    ),
                    child: Container(width: 26,height: 26,child: icon,) ?? const SizedBox(),
                  ),
                  const Wd(),
                  TextWidget(txt: txt ?? '',txtColor: AppColors.primaryColor,),
                ],
              ),
            ),
          ),
          const Hg(height: 10,)
        ],
      ),
    );
  }
}
