import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class PhoneInput extends StatelessWidget {
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Color? color;
  final IconData? suffixIcon;
  final String? image;
  final TextEditingController? controller;
  final double? height;
  final double? widht;
  final double? inputWidth;
  final double? inputHeight;

  final double? sizeBox;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLenght;
  final String? TextLable;
  final bool? isVisible;
  final VoidCallback? iconTap;
  final bool? readOnly;
  final double? radius;
  final Widget? stayle;

  const PhoneInput({
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
    this.inputHeight,
    this.stayle,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label ?? "",
              style: TextStyle(
                color: color ?? AppColors.whiteColor,
                fontSize: 14.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Container(
          height: inputHeight ?? 40,
          width: inputWidth ?? 300.w,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 12.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            ),
            readOnly: readOnly ?? false,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: [
              MaskedInputFormatter('(00) 000-00-00'),

            ],
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
              filled: true,
              fillColor: color ?? AppColors.primaryColor,
              prefix: TextWidget(txt: "+998 ",size: 14,)
            ),
          ),
        ),

        SizedBox(
          height: height,
          width: widht,
        )
      ],
    );
  }
}
