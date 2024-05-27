import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/screens/customer/cubit/customer_cubit.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/types/types_cubit.dart';
import 'package:santexnika_crm/widgets/buttons.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:get/get.dart';

import '../../../errors/service_error.dart';
import '../../../tools/appColors.dart';
import '../../../widgets/sized_box.dart';
import '../../../widgets/text_widget/text_widget.dart';
import '../../settings/cubit/price/price_cubit.dart';

class PayOffDebtDesktopUI extends StatefulWidget {
  final String? price;
  final int? id;

  const PayOffDebtDesktopUI({
    super.key,
    this.price,
    this.id,
  });

  @override
  State<PayOffDebtDesktopUI> createState() => _PayOffDebtDesktopUIState();
}

class _PayOffDebtDesktopUIState extends State<PayOffDebtDesktopUI> {
  int? selectedValuee;
  int? typesId;

  bool isAll = false;

  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtComment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BlocBuilder<PriceCubit, PriceState>(
          builder: (context, state) {
            if (state is PriceLoadingState) {
              return const CircularProgressIndicator.adaptive();
            } else if (state is PriceErrorState) {
              return const Center(child: TextWidget(txt: postError));
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextWidget(
              txt: "Qarzni hammasni to'lash",
              size: 14,
            ),
            Checkbox(
              value: isAll,
              onChanged: (v) {
                setState(() {
                  isAll = !isAll;
                  if (isAll) {
                    txtPrice.text = widget.price.toString();
                  } else {
                    txtPrice.clear();
                  }
                });
              },
            ),
          ],
        ),
        PostInput(
          controller: txtPrice,
          label: 'Qarzini kiriting',
          inputWidth: double.infinity,
        ),
        PostInput(
          controller: txtComment,
          label: "Izoh",
          inputWidth: double.infinity,
        ),
        CustomButtons(
          onTap: () {
            print(widget.id!);
            context
                .read<CustomerWithIdCubit>()
                .payCustomer(
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
          },
        )
      ],
    );
  }
}

class AddDebtDesktopUI extends StatefulWidget {
  final String? price;
  final int? id;
  final bool forCustomer;

  const AddDebtDesktopUI(
      {super.key, this.price, this.id, required this.forCustomer});

  @override
  State<AddDebtDesktopUI> createState() => _AddDebtDesktopUIState();
}

class _AddDebtDesktopUIState extends State<AddDebtDesktopUI> {
  int? selectedValuee;
  int? typesId;

  bool isAll = false;

  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtComment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     const TextWidget(
        //       txt: "Qarzni hammasni to'lash",
        //       size: 14,
        //     ),
        //     Checkbox(
        //       value: isAll,
        //       onChanged: (v) {
        //         setState(() {
        //           isAll = !isAll;
        //           if (isAll) {
        //             txtPrice.text = widget.price.toString();
        //           } else {
        //             txtPrice.clear();
        //           }
        //         });
        //       },
        //     ),
        //   ],
        // ),
        PostInput(
          controller: txtPrice,
          label: 'Qarzini kiriting',
          inputWidth: double.infinity,
        ),
        PostInput(
          controller: txtComment,
          label: "Izoh",
          inputWidth: double.infinity,
        ),
        CustomButtons(
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
        )
      ],
    );
  }
}
