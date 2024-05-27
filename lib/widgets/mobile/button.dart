import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class MobileButton extends StatelessWidget {
  final Color? color;
  final Color? labelColor;
  final String? label;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? radius;
  final VoidCallback? onTap;
  final bool? isVisible;
  final Widget? icon;
  final FontWeight? labelFontWight;
  final Color? borderColor;
  final bool progress;

  const MobileButton({
    Key? key,
    this.color,
    this.label,
    this.width,
    this.height,
    this.onTap,
    this.labelColor,
    this.fontSize,
    this.icon,
    this.labelFontWight,
    this.borderColor,
    this.isVisible,
    this.progress = false,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width ?? 170,
        decoration: BoxDecoration(
          color: color ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(radius ?? 8),
          border: Border.all(
            color: borderColor ?? AppColors.borderColor,
          ),
        ),
        child: progress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: isVisible ?? true,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const SizedBox(width: 8),
                          Container(
                            height: 30,
                            width: 30,
                            child: icon ?? const SizedBox(),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextWidget(
                        txt: label ?? "",
                        fontWeight: labelFontWight ?? FontWeight.w600,
                        size: fontSize ?? 14,
                        elips: true,
                        txtColor: labelColor ?? Colors.white,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
