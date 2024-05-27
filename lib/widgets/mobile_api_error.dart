import 'package:flutter/material.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../tools/appColors.dart';

class MobileAPiError extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const MobileAPiError({super.key, required this.message, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextWidget(txt: message),
        Hg(),
        InkWell(
          onTap: onTap,
          child: Icon(
            Icons.refresh,
            color: AppColors.whiteColor,
            size: 40,
          ),
        )
      ],
    );
  }
}
