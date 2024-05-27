import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/tools/appColors.dart';

import '../../../../widgets/mobile/button.dart';
import '../../../../widgets/mobile/mobile_input.dart';
import '../../../../widgets/sized_box.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import '../../cubit/price/price_cubit.dart';

class MobileUpdatePrice extends StatefulWidget {
  final int id;
  final String name;
  final String value;

  const MobileUpdatePrice(
      {super.key, required this.name, required this.value, required this.id});

  @override
  State<MobileUpdatePrice> createState() => _MobileUpdatePriceState();
}

class _MobileUpdatePriceState extends State<MobileUpdatePrice> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtValue = TextEditingController();

  @override
  void initState() {
    txtName.text = widget.name;
    txtValue.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextWidget(txt: "${widget.name}ni o'zgartirsh"),
          const Hg(),
          MobileInput(
            controller: txtName,
            label: "Nomi",
          ),
          const Hg(),
          MobileInput(
            controller: txtValue,
            label: "Value",
            keyboardType: TextInputType.number,
          ),
          Hg(),
          Row(
            children: [
              Expanded(
                child: MobileButton(
                  label: "Bekor qilish",
                  icon: Icon(
                    Icons.exit_to_app,
                    color: AppColors.whiteColor,
                    size: 20,
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              Wd(),
              Expanded(
                child: MobileButton(
                  onTap: () async {
                    context
                        .read<PriceCubit>()
                        .updatePrice(
                          widget.id!,
                          txtName.text,
                          double.parse(txtValue.text),
                        )
                        .then(
                      (value) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (timeStamp) {
                            context.read<PriceCubit>().getPrice();
                          },
                        );
                        Get.back();
                      },
                    );
                  },
                  label: "Saqlash",
                  icon: Icon(
                    Icons.save,
                    color: AppColors.whiteColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
