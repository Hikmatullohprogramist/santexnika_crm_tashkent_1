import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/screens/customer/cubit/customer_cubit.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/types/types_cubit.dart';
import 'package:santexnika_crm/widgets/buttons.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:get/get.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/input/post_input.dart';
import '../../../../widgets/sized_box.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import '../../../settings/cubit/price/price_cubit.dart';

class DebUpdateWidget extends StatefulWidget {
  final double allPrice;
  final int id;
  final int debtId;
  final String? comment;
  final int? selectedValuee;
  final int? selectedTypesValuee;
  final bool forFirms;

  const DebUpdateWidget({
    Key? key,
    required this.allPrice,
    required this.id,
    this.selectedValuee,
    this.selectedTypesValuee,
    required this.debtId,
    this.comment,
    required this.forFirms,
  }) : super(key: key);

  @override
  State<DebUpdateWidget> createState() => _DebUpdateWidgetState();
}

class _DebUpdateWidgetState extends State<DebUpdateWidget> {
  TextEditingController txtAllPrice = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtIzoh = TextEditingController();
  int? selectedValuee;
  int? selectedTypesValuee;

  @override
  void initState() {
    txtPrice.text = widget.allPrice.toString();
    txtIzoh.text = widget.comment ?? "";
    selectedValuee = widget.selectedValuee;
    selectedTypesValuee = widget.selectedTypesValuee;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const TextWidget(txt: "Firma qarzni o'zgartirish"),
        Column(
          children: [
            BlocBuilder<PriceCubit, PriceState>(
              builder: (context, state) {
                if (state is PriceLoadingState || state is PriceErrorState) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is PriceErrorState) {
                  return TextWidget(
                    txt: state.error,
                  ); // Ensure postError is defined
                } else if (state is PriceSuccessState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        txt: "Pul turini tanlang!",
                        size: 14,
                      ),
                      const Hg(),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: AppColors.borderColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: AppColors.primaryColor,
                            focusColor: Colors.black,
                            value: selectedValuee,
                            items: state.data.map((value) {
                              return DropdownMenuItem(
                                value: value.id,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  child: TextWidget(
                                    txt: value.name ?? "",
                                    txtColor: Colors.white,
                                    size: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedValuee = value;
                              });
                            },
                            isExpanded: true,
                            hint: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
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
            Hg(
              height: 20.h,
            ),
            BlocBuilder<TypesCubit, TypesState>(
              builder: (context, state) {
                if (state is TypesLoadingState || state is TypesErrorState) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is TypesErrorState) {
                  return TextWidget(
                    txt: state.error,
                  ); // Ensure postError is defined
                } else if (state is TypesSuccessState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        txt: "Turini tanlang!",
                        size: 14,
                      ),
                      const Hg(),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: AppColors.borderColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: AppColors.primaryColor,
                            focusColor: Colors.black,
                            value: selectedTypesValuee,
                            items: state.data.map((value) {
                              return DropdownMenuItem(
                                value: value.id,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  child: TextWidget(
                                    txt: value.name ?? "",
                                    txtColor: Colors.white,
                                    size: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedTypesValuee = value;
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
            Hg(
              height: 20.h,
            ),
            PostInput(
              controller: txtPrice,
              label: "To'lanayotgan summa",
              txtColor: Colors.white,
              inputWidth: double.infinity,
              radius: 5,
            ),
            Hg(
              height: 20.h,
            ),
            PostInput(
              controller: txtIzoh,
              label: "Izoh",
              txtColor: Colors.white,
              inputWidth: double.infinity,
              radius: 5,
            ),
          ],
        ),
        CustomButtons(
          onTap: () {
            if (txtPrice.text.isNotEmpty &&
                selectedTypesValuee != null &&
                selectedValuee != null) {
              if (widget.forFirms) {
                context
                    .read<ShowCompanyCubit>()
                    .updatePayCompany(
                      selectedValuee!,
                      selectedTypesValuee!,
                      double.parse(txtPrice.text),
                      widget.debtId,
                      widget.id,
                      txtIzoh.text,
                    )
                    .then(
                      (value) => Navigator.pop(context),
                    );
              } else {
                errorDialogWidgets(context);
              }
              if (txtPrice.text.isNotEmpty &&
                  selectedTypesValuee != null &&
                  selectedValuee != null) {
                context
                    .read<ShowCompanyCubit>()
                    .updatePayCompany(
                      selectedValuee ?? 0,
                      selectedTypesValuee ?? 0,
                      double.parse(txtPrice.text),
                      widget.debtId,
                      widget.id,
                      txtIzoh.text,
                    )
                    .then(
                      (value) => Navigator.pop(context),
                    );
              } else {
                if (txtPrice.text.isNotEmpty &&
                    selectedTypesValuee != null &&
                    selectedValuee != null) {
                  context
                      .read<CustomerWithIdCubit>()
                      .updatePayCustomer(
                        selectedValuee ?? 0,
                        selectedTypesValuee ?? 0,
                        double.parse(txtPrice.text),
                        widget.debtId,
                        widget.id,
                        txtIzoh.text,
                      )
                      .then(
                    (value) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (timeStamp) async {
                          context
                              .read<CustomerWithIdCubit>()
                              .getCustomerWithId(widget.id);
                        },
                      );
                      Get.back();
                    },
                  );
                } else {
                  errorDialogWidgets(context);
                }
              }
            }
          },
        )
      ],
    );
  }
}
