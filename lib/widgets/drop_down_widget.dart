// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../tools/appColors.dart';

class DropDownWidgets extends StatefulWidget {
  final List<String> items;
  final String selectedValue;
  final Function onChanged;
  final String? txt;
  final String? name;
  final double? width;
  final double? height;
  final double? radius;
  final bool? isVisible;
  final Color? backgroundColor;

  const DropDownWidgets({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.txt,
    this.width,
    this.name,
    this.height,
    this.radius,
    this.isVisible,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<DropDownWidgets> createState() => _DropDownWidgetsState();
}

class _DropDownWidgetsState extends State<DropDownWidgets> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.isVisible ?? true,
          child: Column(
            children: [
              TextWidget(
                txt: widget.txt ?? "",
                size: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
        Container(
          height: widget.height ?? 40.spMax,
          width: widget.width ?? 300.w,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.primaryColor,
            borderRadius: BorderRadius.circular(widget.radius ?? 20.r),
            border: Border.all(
              color: AppColors.borderColor,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              value: widget.selectedValue,
              items: widget.items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextWidget(
                      txt: value,
                      txtColor: Colors.black,
                      size: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                widget.onChanged(value);
              },
              isExpanded: true,
              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(widget.name ?? ""),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
