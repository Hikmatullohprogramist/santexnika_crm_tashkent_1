// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';

class ParolInput extends StatefulWidget {
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Color? color;
  final Widget? suffixIcon;
  final String? image;
  final TextEditingController? controller;
  final double? height;
  final double? widht;
  final double? inputWidth;
  final double? sizeBox;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLenght;
  final String? TextLable;
  final bool? isVisible;
  final VoidCallback? iconTap;
  final bool? readOnly;
  final int miLenght;

  const ParolInput({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.label,
    this.height,
    this.widht,
    this.inputWidth,
    this.image,
    this.sizeBox,
    this.color,
    this.keyboardType,
    this.inputFormatter,
    this.maxLenght,
    this.TextLable,
    this.isVisible,
    this.iconTap,
    this.readOnly,
    required this.miLenght,
  });

  @override
  State<ParolInput> createState() => _ParolInputState();
}

class _ParolInputState extends State<ParolInput> {
  var errortext = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label ?? "",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        //Container(
        //           height: inputHeight ?? 40,
        //           width: inputWidth ?? 300.w,
        //           decoration: BoxDecoration(
        //             border: Border.all(color: AppColors.borderColor, width: 1),
        //             borderRadius: BorderRadius.circular(5),
        //           ),
        //           child: TextField(
        //             onChanged: onChanged,
        //             style: TextStyle(
        //               color: AppColors.whiteColor,
        //               fontSize: 12,
        //               fontFamily: 'Open Sans',
        //               fontWeight: FontWeight.w400,
        //             ),
        //             readOnly: readOnly ?? false,
        //             controller: controller,
        //             keyboardType: keyboardType,
        //             inputFormatters: inputFormatter,
        //             decoration: InputDecoration(
        //               hintText: hintText,
        //               hintStyle: TextStyle(
        //                 color: AppColors.whiteColor,
        //                 fontSize: 12,
        //               ),
        //               border: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(5),
        //                 borderSide: BorderSide.none,
        //               ),
        //               contentPadding:
        //                   EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
        //               filled: true,
        //               fillColor: color ?? AppColors.primaryColor,
        //               prefixIcon: prefixIcon,
        //             ),
        //           ),
        //         ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: widget.inputWidth ?? 300.w,
              height: 46,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: AppColors.borderColor, width: 1.w),
                  color: widget.color ?? Colors.transparent),
              child: TextField(
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                onChanged: (value) {
                  setState(() {
                    if (widget.miLenght != 0) {
                      if (value.length < widget.miLenght) {
                        print(value);

                        errortext =
                            "Minimum ${widget.miLenght} ta bo`lishi kerak";
                      } else {
                        errortext = "";
                      }
                    } else {
                      errortext = "";
                    }
                  });
                },
                maxLength: widget.maxLenght,
                readOnly: widget.readOnly ?? false,
                inputFormatters: widget.inputFormatter,
                obscureText: widget.isVisible ?? true,
                style:   TextStyle(fontSize: 12,  color: AppColors.whiteColor),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                  filled: true,
                  fillColor: widget.color ?? AppColors.primaryColor,
                  suffixIcon: widget.suffixIcon ?? const SizedBox()
                ),
              ),
            ),
            const Hg(),
            Text(
              errortext,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
              ),
            )
          ],
        ),
        SizedBox(
          height: widget.height,
          width: widget.widht,
        )
      ],
    );
  }
}
