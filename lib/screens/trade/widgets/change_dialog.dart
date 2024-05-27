import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_cubit.dart';

import '../../../errors/service_error.dart';
import '../../../models/basket/basket_model.dart';
import '../../../tools/appColors.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/input/post_input.dart';
import '../../../widgets/sized_box.dart';
import '../../../widgets/text_widget/text_widget.dart';
import '../../settings/cubit/price/price_cubit.dart';

class TradeChangeDialog extends StatefulWidget {
  final BasketModel data;
  final double price;
  final double quantity;
  final int moneyFormId;
  final num dollar;

  const TradeChangeDialog({
    super.key,
    required this.data,
    required this.price,
    required this.quantity,
    required this.moneyFormId,
    required this.dollar,
  });

  @override
  State<TradeChangeDialog> createState() => _TradeChangeDialogState();
}

class _TradeChangeDialogState extends State<TradeChangeDialog> {
  int selectedValueMoneyForm = 1;
  TextEditingController summaController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    quantityController.text = widget.quantity.toString();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextWidget(txt: "O'zgartirish"),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Hg(
              height: 20,
            ),
            BlocBuilder<PriceCubit, PriceState>(
              builder: (context, state) {
                if (state is PriceLoadingState) {
                  return const CircularProgressIndicator.adaptive();
                } else if (state is PriceErrorState) {
                  return const TextWidget(txt: postError);
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
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            value: selectedValueMoneyForm,
                            items: state.data.map((value) {
                              return DropdownMenuItem(
                                value: value.id,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
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
            const Hg(
              height: 20,
            ),
            PostInput(
              inputWidth: MediaQuery.sizeOf(context).width,
              controller: summaController,
              label: 'Narx',
            ),
            const Hg(
              height: 20,
            ),
            PostInput(
              inputWidth: MediaQuery.sizeOf(context).width,
              controller: quantityController,
              label: 'Soni',
            ),
          ],
        ),
        const Wd(),
        CustomButtons(
          onTap: () {
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
        )
      ],
    );
  }
}
