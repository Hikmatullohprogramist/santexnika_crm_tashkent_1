import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class BarTextWidgets extends StatelessWidget {
  final String name;
  final double price;

  const BarTextWidgets({super.key, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          txt: "$name:",
          size: 14.sp,
        ),
        TextWidget(
          txt: moneyFormatter(price),
          size: 14.sp,
        ),
      ],
    );
  }
}
