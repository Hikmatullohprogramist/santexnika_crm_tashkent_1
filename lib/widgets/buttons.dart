import 'package:flutter/material.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:get/get.dart';

class CustomButtons extends StatelessWidget {
  final VoidCallback onTap;

  const CustomButtons({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ButtonWidget(
            label: "Bekor qilish",
            icon: Icons.exit_to_app,
            color: AppColors.primaryColor,
            onTap: () {
              Get.back();
            },
          ),
        ),
        Wd(),
        Expanded(
          child: ButtonWidget(
            icon: Icons.save,
            label: "Saqlash",
            color: AppColors.primaryColor,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
