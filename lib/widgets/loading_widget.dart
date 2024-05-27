import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:santexnika_crm/tools/appColors.dart';

class ApiLoadingWidget extends StatelessWidget {
  const ApiLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        backgroundColor: AppColors.whiteColor,
      ),
    );
  }
}
