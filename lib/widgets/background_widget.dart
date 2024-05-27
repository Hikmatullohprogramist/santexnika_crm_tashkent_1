import 'package:flutter/material.dart';

import '../tools/appColors.dart';

class MobileBackgroundWidget extends StatelessWidget {
  final Widget child;
  final Color? color;
  final VoidCallback? onTap;

  const MobileBackgroundWidget({
    super.key,
    required this.child,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color ?? AppColors.primaryColor,
            border: Border.all(color: AppColors.borderColor, width: 0.1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: AppColors.toqPrimaryColor, spreadRadius: 1)
            ],
          ),
          child: child),
    );
  }
}
