import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/expenses/cubit/expenses_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/price/price_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/types/types_cubit.dart';
import 'package:santexnika_crm/widgets/input/currency_input.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../../tools/appColors.dart';

class MobileExpensesDialog extends StatefulWidget {
  final int? id;
  final bool isBool;
  final String? name;
  final String? comment;
  final int? typeId;
  final int? priceId;
  final String? cost;

  const MobileExpensesDialog({
    super.key,
    required this.isBool,
    this.name,
    this.comment,
    this.typeId,
    this.priceId,
    this.cost,
    this.id,
  });

  @override
  State<MobileExpensesDialog> createState() => _MobileExpensesDialogState();
}

class _MobileExpensesDialogState extends State<MobileExpensesDialog> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtComment = TextEditingController();
  TextEditingController txtCost = TextEditingController();

  int? selectedValuee;
  int? typesValue;

  @override
  void initState() {
    if (widget.isBool) {
    } else {
      txtName.text = widget.name ?? '';
      txtCost.text = widget.cost ?? '';
      txtComment.text = widget.comment ?? '';
      selectedValuee = widget.priceId ?? 1;
      typesValue = widget.typeId ?? 1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.isBool ? "Chiqim qo'shish" : "Chiqimni o'zgartirish";

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(txt: name),
            Hg(),
            MobileInput(
              controller: txtName,
              label: "Nomi",
              inputWidth: double.infinity,
            ),
            Hg(),
            MobileInput(
              controller: txtComment,
              label: "Izoh",
              inputWidth: double.infinity,
            ),
            Hg(),
            CurrencyInput(
              controller: txtCost,
              label: "Summa",
              inputWidth: double.infinity,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                // Allow integers and floating-point numbers
                // Allow only numbers
              ],
            ),
            Hg(),
            BlocBuilder<PriceCubit, PriceState>(
              builder: (BuildContext context, PriceState state) {
                if (state is PriceLoadingState) {
                  return const CircularProgressIndicator.adaptive();
                } else if (state is PriceErrorState) {
                  return const TextWidget(txt: 'txt');
                } else if (state is PriceSuccessState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        txt: "Pul turini  tanlang!",
                        size: 14,
                      ),
                      Hg(
                        height: 8.h,
                      ),
                      Container(
                        height: 40.spMax,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: AppColors.borderColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            dropdownColor: AppColors.primaryColor,
                            focusColor: Colors.black,
                            value: selectedValuee,
                            items: state.data.map((value) {
                              return DropdownMenuItem<int>(
                                value: value.id,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: TextWidget(
                                    txt: value.name ?? "",
                                    txtColor: Colors.white,
                                    size: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (int? value) {
                              setState(() {
                                selectedValuee = value!;
                              });
                            },
                            isExpanded: true,
                            hint: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: const Text(
                                "Pul turini tanlang!",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
            Hg(),
            BlocBuilder<TypesCubit, TypesState>(
              builder: (BuildContext context, TypesState state) {
                if (state is TypesSuccessState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        txt: "Turini tanlang!",
                        size: 14,
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
                            5.r,
                          ),
                          border: Border.all(
                            color: AppColors.borderColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: AppColors.primaryColor,
                            focusColor: Colors.black,
                            value: typesValue,
                            items: state.data.map(
                              (value) {
                                return DropdownMenuItem(
                                  value: value.id,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: TextWidget(
                                      txt: value.name ?? "",
                                      txtColor: Colors.white,
                                      size: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                typesValue = value;
                              });
                            },
                            isExpanded: true,
                            hint: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                              child: const Text(
                                "Turini tanlang!",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
            Hg(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MobileButton(
                    label: "Bekor qilish",
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 20,
                    ),
                    color: AppColors.primaryColor,
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                const Wd(),
                Expanded(
                  child: MobileButton(
                    icon: const Icon(
                      Icons.save,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: "Saqlash",
                    color: AppColors.primaryColor,
                    onTap: () {
                      if (txtName.text.isEmpty ||
                          txtCost.text.isEmpty ||
                          txtCost.text.isEmpty ||
                          selectedValuee == null ||
                          typesValue == null) {
                        print('object');

                        errorDialogWidgets(context);
                      } else {
                        if (widget.isBool) {
                          context
                              .read<ExpensesCubit>()
                              .postExpense(
                                txtName.text,
                                txtComment.text,
                                typesValue!,
                                selectedValuee!,
                                txtCost.text
                                    .trim()
                                    .replaceAll(RegExp(r'[^0-9]'), ''),
                              )
                              .then((_) {
                            Navigator.of(context).pop(); // Close the dialog
                          }).catchError((error) {
                            print(error);
                          });
                        } else {
                          context
                              .read<ExpensesCubit>()
                              .putExpense(
                                widget.id ?? 0,
                                txtName.text,
                                txtComment.text,
                                typesValue ?? 0,
                                selectedValuee ?? 0,
                                txtCost.text.trim().replaceAll(
                                      RegExp(r'[^0-9]'),
                                      '',
                                    ),
                              )
                              .then((_) {
                            Navigator.of(context).pop(); // Close the dialog
                          }).catchError((error) {
                            print(error);
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
