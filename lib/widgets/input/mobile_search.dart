import 'package:flutter/material.dart';

import '../mobile/mobile_input.dart';

class MobileSearchInput extends StatelessWidget {
  final Function(String)? onChanged;

  const MobileSearchInput({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MobileInput(
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        inputWidth: double.infinity,
        visible: false,
        radius: 5,
        hintText: "Qidirish",
        onChanged: onChanged,
      ),
    );
  }
}
