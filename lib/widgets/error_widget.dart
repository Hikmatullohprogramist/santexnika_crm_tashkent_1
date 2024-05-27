import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class ApiErrorMessage extends StatelessWidget {
  final String errorMessage;


  const ApiErrorMessage({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextWidget(
            txt: errorMessage,
            size: 40.sp,
          ),

         ],
      ),
    );
  }
}
