import 'package:flutter/material.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class RowsTextWidget extends StatelessWidget {
  final String? title;
  final String? name;

  const RowsTextWidget({super.key, this.title, this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          txt: title,
          elips: true,
          size: 15,
          fontWeight: FontWeight.w700,
        ),
        Expanded(
          child: TextWidget(
            txt: name,
            elips: true,
            size: 15,
          ),
        ),
      ],
    );
  }
}
