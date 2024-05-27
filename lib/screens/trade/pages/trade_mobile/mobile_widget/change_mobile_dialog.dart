import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../../models/basket/basket_model.dart';
import '../../../../../tools/appColors.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../settings/cubit/price/price_cubit.dart';
import '../../../cubit/waiting/trade_cubit/basket_cubit.dart';

class ChangeMobileDialog extends StatefulWidget {
  final BasketModel data;
  final double price;
  final double quantity;
  final int moneyFormId;
  final num dollar;

  const ChangeMobileDialog({
    super.key,
    required this.data,
    required this.price,
    required this.quantity,
    required this.moneyFormId,
    required this.dollar,
  });

  @override
  State<ChangeMobileDialog> createState() => _ChangeMobileDialogState();
}

class _ChangeMobileDialogState extends State<ChangeMobileDialog> {
  int selectedValueMoneyForm = 1;
  TextEditingController summaController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    quantityController.text = widget.quantity.toString();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TextWidget(txt: "O'zgartirish"),
          BlocBuilder<PriceCubit, PriceState>(
            builder: (context, state) {
              if (state is PriceLoadingState) {
                return const CircularProgressIndicator.adaptive();
              } else if (state is PriceErrorState) {
                return TextWidget(txt: state.error);
              } else if (state is PriceSuccessState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      txt: 'Pul turi',
                      size: 14.sp,
                    ),
                    Hg(
                      height: 8.h,
                    ),
                    Container(
                      height: 40.spMax,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(
                          10.r,
                        ),
                        border: Border.all(
                          color: AppColors.borderColor,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          value: selectedValueMoneyForm,
                          items: state.data.map((value) {
                            return DropdownMenuItem(
                              value: value.id,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: TextWidget(
                                  txt: value.name,
                                  txtColor: Colors.white,
                                  size: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedValueMoneyForm = value!;
                            print(widget.moneyFormId);
                            if (widget.moneyFormId == 2) {
                              if (selectedValueMoneyForm != 2) {
                                double result = widget.price * widget.dollar;
                                summaController.text =
                                    result.toStringAsFixed(2);
                              } else {
                                summaController.text =
                                    widget.price.toStringAsFixed(2);
                              }
                            } else if (widget.moneyFormId == 1) {
                              if (selectedValueMoneyForm != 1) {
                                double result = widget.price / widget.dollar;
                                summaController.text =
                                    result.toStringAsFixed(2);
                              } else {
                                summaController.text =
                                    widget.price.toStringAsFixed(2);
                              }
                            }

                            setState(
                              () {},
                            );
                          },
                          dropdownColor: AppColors.primaryColor,
                          isExpanded: true,
                          hint: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                            child: const Text(
                              "Pul turini tanlang",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          MobileInput(
            controller: summaController,
            label: "Narx",
          ),
          MobileInput(
            controller: quantityController,
            label: "Soni",
          ),
          const Hg(),
          Row(
            children: [
              Expanded(
                child: MobileButton(
                  label: "Bekor qilish",
                  onTap: (){
                    Get.back();
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
              const Wd(),
              Expanded(
                child: MobileButton(
                  label: "Saqlash",
                  onTap: (){
                    context
                        .read<BasketCubit>()
                        .updateBasket(
                      widget.data.storeId,
                      selectedValueMoneyForm,
                      double.parse(summaController.text.trim()),
                      double.parse(
                        quantityController.text.trim(),
                      ),
                    )
                        .then(
                          (value) {
                        // Get.back();
                        Get.back();
                      },
                    );
                  },
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 20.sp,
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
