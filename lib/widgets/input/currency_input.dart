// ignore_for_file: non_constant_identifier_names, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:santexnika_crm/tools/appColors.dart';

class CurrencyInput extends StatefulWidget {
  final String? label;
  final String? hintText;
  final Color? color;
  final Color? txtColor;
  final String? image;
  final TextEditingController? controller;
  final double? height;
  final double? widht;
  final double? inputWidth;
  final double? inputHeight;
  final bool? visible;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? sizeBox;
  final double? radius;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLenght;
  final String? TextLable;
  final VoidCallback? iconTap;
  final bool? readOnly;
  final Widget? stayle;
  final MainAxisAlignment? mainAxisAlignment;
  final Function(String)? onChanged;

  const CurrencyInput({
    super.key,
    this.hintText,
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
    this.iconTap,
    this.readOnly,
    this.inputHeight,
    this.stayle,
    this.onChanged,
    this.visible,
    this.prefixIcon,
    this.txtColor,
    this.radius,
    this.mainAxisAlignment,
    this.suffixIcon,
  });

  @override
  State<CurrencyInput> createState() => _PostInputState();
}

class _PostInputState extends State<CurrencyInput> {
  final _subscriptionFormKey = GlobalKey<FormState>();

  final NumberFormat numFormat = NumberFormat('###,###', 'uz_UZ');

  final NumberFormat numSanitizedFormat = NumberFormat('uz_UZ');

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.visible ?? true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label ?? "",
                style: TextStyle(
                  color: widget.txtColor ?? Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 8.h,
              ),
            ],
          ),
        ),
        Container(
          height: widget.inputHeight ?? 40,
          width: widget.inputWidth ?? 300.w,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (price) {
              if (price == '') price = '0';
              final formattedPrice = numFormat.format(
                double.parse(price),
              );
              debugPrint('Formatted $formattedPrice');
              widget.controller!.value = TextEditingValue(
                text: formattedPrice,
                selection: TextSelection.collapsed(
                  offset: formattedPrice.length,
                ),
              );
            },
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 12.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            ),
            readOnly: widget.readOnly ?? false,
            controller: widget.controller,
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
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
        ),
        SizedBox(
          height: widget.height,
          width: widget.widht,
        )
      ],
    );
  }
}
