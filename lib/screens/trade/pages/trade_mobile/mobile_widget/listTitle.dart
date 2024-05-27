import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/tools/appColors.dart';

import '../../../../../models/basket/basket_model.dart';
import '../../../../../widgets/background_widget.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../../settings/cubit/price/price_cubit.dart';
import '../../../cubit/waiting/trade_cubit/basket_cubit.dart';

class TradeListTitle extends StatefulWidget {
  final String? txt;
  final double? quality;
  final double? price;
  final double? allPrice;
  final String? types;
  final Color? color;
  final BasketModel data;
  final double quantity;
  final int moneyFormId;
  final num dollar;

  const TradeListTitle(
      {super.key,
      this.txt,
      this.quality,
      this.types,
      this.price,
      this.allPrice,
      this.color,
      required this.moneyFormId,
      required this.data,
      required this.quantity,
      required this.dollar});

  @override
  State<TradeListTitle> createState() => _TradeListTitleState();
}

class _TradeListTitleState extends State<TradeListTitle> {
  final qualityController = TextEditingController();
  final summaController = TextEditingController();
  final allSummaController = TextEditingController();

  @override
  void initState() {
    qualityController.text = widget.quality.toString();
    summaController.text = widget.price.toString();
    allSummaController.text = widget.allPrice.toString();
    selectedValueMoneyForm = widget.moneyFormId;
    super.initState();
  }

  int? selectedValueMoneyForm;

  @override
  Widget build(BuildContext context) {
    return MobileBackgroundWidget(
      color: widget.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'Nomi: ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    )),
                TextSpan(
                  text: widget.txt ?? "",
                ),
              ],
            ),
          ),
          const Hg(),
          Row(
            children: [
              Expanded(
                child: TextWidget(
                  txt: "Miqdori:",
                  size: 16.sp,
                  fontWeight: FontWeight.w700,
                  elips: true,
                ),
              ),
              const Wd(),
              Expanded(
                child: TextWidget(
                  txt: "Valyuta:",
                  size: 16.sp,
                  fontWeight: FontWeight.w700,
                  elips: true,
                ),
              ),
            ],
          ),
          Hg(
            height: 5.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: qualityController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp(r'[0-9\.]'),
                        allow: true),
                  ],
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              const Wd(),
              BlocBuilder<PriceCubit, PriceState>(
                builder: (context, state) {
                  if (state is PriceLoadingState) {
                    return const CircularProgressIndicator.adaptive();
                  } else if (state is PriceErrorState) {
                    return TextWidget(txt: state.error);
                  } else if (state is PriceSuccessState) {
                    return Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          value: selectedValueMoneyForm,
                          items: state.data.map((value) {
                            return DropdownMenuItem(
                              value: value.id,
                              child: TextWidget(
                                txt: value.name,
                                txtColor: Colors.white,
                                size: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedValueMoneyForm = value!;
                            print(widget.moneyFormId);
                            if (widget.moneyFormId == 2) {
                              if (selectedValueMoneyForm != 2) {
                                double result = widget.price! * widget.dollar;
                                summaController.text =
                                    result.toStringAsFixed(2);
                              } else {
                                summaController.text =
                                    widget.price!.toStringAsFixed(2);
                              }
                            } else if (widget.moneyFormId == 1) {
                              if (selectedValueMoneyForm != 1) {
                                double result = widget.price! / widget.dollar;
                                summaController.text =
                                    result.toStringAsFixed(2);
                              } else {
                                summaController.text =
                                    widget.price!.toStringAsFixed(2);
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
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
          const Hg(),
          Row(
            children: [
              Expanded(
                child: TextWidget(
                  txt: "Summa",
                  size: 16.sp,
                  fontWeight: FontWeight.w700,
                  elips: true,
                ),
              ),
              const Wd(),
              Expanded(
                child: TextWidget(
                  txt: "Jami Summa:",
                  size: 16.sp,
                  fontWeight: FontWeight.w700,
                  elips: true,
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          Hg(
            height: 5.h,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: summaController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              const Wd(),
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: allSummaController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<BasketCubit>().updateBasket(
                          widget.data.storeId,
                          selectedValueMoneyForm!,
                          double.parse(summaController.text.trim()),
                          double.parse(
                            qualityController.text.trim(),
                          ),
                        );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.done_all,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
