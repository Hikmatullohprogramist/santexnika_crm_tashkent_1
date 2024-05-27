

import 'package:flutter/material.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../tools/appColors.dart';

class StatisticBarWidget extends StatefulWidget {
  final String name;
  const StatisticBarWidget({super.key, required this.name});

  @override
  State<StatisticBarWidget> createState() => _StatisticBarWidgetState();
}

class _StatisticBarWidgetState extends State<StatisticBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      color: AppColors.primaryColor,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextWidget(txt: widget.name??'',),
        ],
      ),
    );
  }
}
