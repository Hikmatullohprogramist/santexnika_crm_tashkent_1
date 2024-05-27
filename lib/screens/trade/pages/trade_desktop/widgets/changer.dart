import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_cubit.dart';
 import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../errors/service_error.dart';
import '../../../../../models/basket/basket_model.dart';
import '../../../../../tools/appColors.dart';
import '../../../../../widgets/buttons.dart';
import '../../../../../widgets/input/post_input.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../../settings/cubit/price/price_cubit.dart';

class TradeDialogChanger extends StatefulWidget {
  final BasketModel data;

  const TradeDialogChanger({super.key, required this.data,  });

  @override
  State<TradeDialogChanger> createState() => _TradeDialogChangerState();
}

class _TradeDialogChangerState extends State<TradeDialogChanger> {
  TextEditingController summaController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  int selectedValueMoneyForm = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Hg(),
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
                        width: double.infinity,
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
                            dropdownColor: AppColors.primaryColor,
                            value: selectedValueMoneyForm,
                            items: state.data.map((value) {
                              return DropdownMenuItem(
                                value: value.id,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
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
                              setState(
                                () {},
                              );
                            },
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
            const Hg(),
            PostInput(
              inputWidth: double.infinity,
              controller: summaController,
              keyboardType: TextInputType.number,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              label:
                  'Narx(${widget.data.basketPrice[0].priceType.id != 1 ? "So`m" : "Dollar"})',
            ),
            const Hg(),
            PostInput(
              inputWidth: double.infinity,
              controller: quantityController,
              keyboardType: TextInputType.number,
              label: 'Soni',
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
          ],
        ),
        const Wd(),
        CustomButtons(
          onTap: () {
            context.read<BasketCubit>().updateBasket(
                  widget.data.storeId,
                  selectedValueMoneyForm,
                  double.parse(summaController.text.trim()),
                  double.parse(
                    quantityController.text.trim(),
                  ),
                );
          },
        ),
      ],
    );
  }
}
