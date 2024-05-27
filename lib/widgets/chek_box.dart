import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class CheckBoxWidget extends StatefulWidget {
  final bool? isVisible;
  final String? txt;
  final double? size;
  final void Function(bool?)? onTap;
  final Function()? onTap1;

  const CheckBoxWidget({
    super.key,
    this.isVisible,
    this.txt,
    this.onTap, this.onTap1, this.size,
  });

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.isVisible,
          onChanged: widget.onTap,
        ),
        GestureDetector(
          onTap: widget.onTap1, // Buni o'zgartirdim
          child: TextWidget(txt: widget.txt ?? '',size:widget.size??18.sp ,),
        ),
      ],
    );

  }
}
