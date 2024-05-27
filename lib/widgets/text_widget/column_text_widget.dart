import 'package:flutter/material.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class ColumnTextWidget extends StatelessWidget {
  final String? title;
  final String? name;

  const ColumnTextWidget({super.key, this.title, this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          txt: title,
          elips: true,
          size: 15,
          fontWeight: FontWeight.w700,
        ),
        Hg(
          height: 5,
        ),
        TextWidget(
          txt: name,
          elips: true,
          size: 15,
        ),
      ],
    );
  }
}
