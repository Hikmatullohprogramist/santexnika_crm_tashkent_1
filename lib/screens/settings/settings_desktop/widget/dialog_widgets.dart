import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/input/post_input.dart';
import '../../../../widgets/sized_box.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import 'package:get/get.dart';

class DialogWidgets extends StatefulWidget {
  final String? txtName;
  final String? txtFiledName;
  final String? txtFiledName1;
  final TextEditingController? txtFiledController;
  final TextEditingController? txtFiledController1;
  final bool? visible;
  final bool? allVisible;
  final VoidCallback? onTap;
  final List<String>? items;
  final String? selectedValue;
  final Function? onChanged;
  final String? txt;
  final Widget? child;

  const DialogWidgets({
    super.key,
    this.txtName,
    this.txtFiledName,
    this.txtFiledName1,
    this.txtFiledController,
    this.txtFiledController1,
    this.visible,
    this.onTap,
    this.items,
    this.selectedValue,
    this.onChanged,
    this.txt,
    this.child,
    this.allVisible,
  });

  @override
  State<DialogWidgets> createState() => _DialogWidgetsState();
}

class _DialogWidgetsState extends State<DialogWidgets> {
  int? selectedValuee;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 350.h,
        width: 500.w,
        decoration: BoxDecoration(
            color: AppColors.bottombarColor,
            borderRadius: BorderRadius.circular(10)),
        child: Material(
          color: AppColors.bottombarColor,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(txt: "${widget.txtName} qo'shish"),
                    Hg(
                      height: 30.h,
                    ),
                    PostInput(
                      controller: widget.txtFiledController,
                      inputWidth: double.infinity,
                      label: widget.txtFiledName,
                    ),
                    Hg(
                      height: 20.h,
                    ),
                    Visibility(
                      visible: widget.allVisible ?? true,
                      child: Column(
                        children: [
                          widget.visible == true
                              ? Container(
                                  height: 40.spMax,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(0.r),
                                    border: Border.all(
                                      color: AppColors.borderColor,
                                    ),
                                  ),
                                  child: widget.child,
                                )
                              : PostInput(
                                  controller: widget.txtFiledController1,
                                  inputWidth: double.infinity,
                                  label: widget.txtFiledName1,
                                )
                        ],
                      ),
                    )
                  ],
                ),
                Hg(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonWidget(
                      width: 200.w,
                      label: "Bekor qilish",
                      icon: Icons.exit_to_app,
                      color: AppColors.primaryColor,
                      onTap: () {
                        Get.back();
                      },
                    ),
                    ButtonWidget(
                      width: 200.w,
                      icon: Icons.save,
                      label: "Saqlash",
                      color: AppColors.primaryColor,
                      onTap: widget.onTap,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
