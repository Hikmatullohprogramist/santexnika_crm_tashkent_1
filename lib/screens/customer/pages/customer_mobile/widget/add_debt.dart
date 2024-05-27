import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';

import '../../../../../errors/service_error.dart';
import '../../../../../tools/appColors.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../../settings/cubit/price/price_cubit.dart';
import '../../../../settings/cubit/types/types_cubit.dart';
import '../../../cubit/customer_cubit.dart';

class MobileAddDebtUI extends StatefulWidget {
  final String? price;
  final int? id;
  final bool forCustomer;

  const MobileAddDebtUI(
      {super.key, this.price, this.id, required this.forCustomer});

  @override
  State<MobileAddDebtUI> createState() => _MobileAddDebtUIState();
}

class _MobileAddDebtUIState extends State<MobileAddDebtUI> {
  int? selectedValuee;
  int? typesId;

  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtComment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TextWidget(txt: "Qarz yozish"),
            Hg(),
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
                                "Pul turini tanlang",
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
              builder: (context, state) {
                if (state is TypesLoadingState) {
                  return const CircularProgressIndicator.adaptive();
                } else if (state is TypesErrorState) {
                  return const TextWidget(txt: postError);
                } else if (state is TypesSuccessState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        txt: 'Turini turi',
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
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: AppColors.borderColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: AppColors.primaryColor,
                            focusColor: Colors.black,
                            value: typesId,
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
                                typesId = value;
                              });
                            },
                            isExpanded: true,
                            hint: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                              child: const Text(
                                "Turini tanlang",
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
            MobileInput(
              controller: txtPrice,
              label: "Qarzi",
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatter: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                    r'^\d*\.?\d*$',
                  ),
                ), // Allow only numbers
              ],
            ),
            Hg(),
            MobileInput(
              controller: txtComment,
              label: "Izoh",
            ),
            Hg(),
            const Hg(),
            Row(
              children: [
                Expanded(
                  child: MobileButton(
                    label: "Bekor qilish",
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 20,
                    ),
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
                    onTap: () {
                      if (widget.forCustomer) {
                        context
                            .read<CustomerWithIdCubit>()
                            .addDebtCustomer(
                              widget.id ?? 0,
                              selectedValuee ?? 0,
                              typesId ?? 0,
                              double.parse(txtPrice.text),
                              txtComment.text,
                            )
                            .then(
                          (value) {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (timeStamp) async {
                                context
                                    .read<CustomerWithIdCubit>()
                                    .getCustomerWithId(widget.id!);
                              },
                            );
                            Get.back();
                          },
                        );
                      } else {
                        context
                            .read<ShowCompanyCubit>()
                            .addDebtCompany(
                              widget.id ?? 0,
                              selectedValuee ?? 0,
                              typesId ?? 0,
                              double.parse(txtPrice.text),
                              txtComment.text,
                            )
                            .then(
                          (value) {
                            Get.back();
                          },
                        );
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
