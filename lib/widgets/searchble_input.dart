import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';

import 'input/post_input.dart';

class SearchInput extends StatelessWidget {
  final Function(String)? onChanged;
  final bool? isBool;
  final VoidCallback?onTap;
  final double?width;

  const SearchInput({super.key, this.onChanged, this.isBool, this.onTap, this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: isBool ?? false,
          child: Row(
            children: [
              const Wd(),
              InkWell(
                onTap: onTap,
                child: const Icon(
                  Icons.arrow_circle_left_outlined,
                  color: Colors.white,
                ),
              ),
              const Wd(),
            ],
          ),
        ),
        PostInput(
          inputWidth: width??300.w,
          onChanged: onChanged,
          hintText: "Qidirish ...",
          visible: false,
          mainAxisAlignment: MainAxisAlignment.center,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white,
            size: 18,
          ),
        ),
      ],
    );
  }
}
