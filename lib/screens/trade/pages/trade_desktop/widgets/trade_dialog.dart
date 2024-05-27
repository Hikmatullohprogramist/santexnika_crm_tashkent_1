import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/models/basket/basket_model.dart';
import 'package:santexnika_crm/models/basket/save_basket_model.dart';
import 'package:santexnika_crm/screens/settings/cubit/types/types_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_state.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_desktop/widgets/check.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/constantas.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';

import '../../../../../models/customer/customerModel.dart';
import '../../../../../widgets/input/post_input.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../../customer/cubit/customer_cubit.dart';
import '../../../../settings/cubit/price/price_cubit.dart';
import 'printa4.dart';

class TradeDialog extends StatefulWidget {
  final List<BasketModel> products;
  final num dollarPirce;
  final num somPrice;

  const TradeDialog({
    super.key,
    required this.products,
    required this.dollarPirce,
    required this.somPrice,
  });

  @override
  State<TradeDialog> createState() => _TradeDialogState();
}

class _TradeDialogState extends State<TradeDialog> {
  int? selectedValueMoneyForm;
  int? typeSelected;
  int? customerId;
  CustomerModel? customerModel;

  final List<TradeController> _tradeController = [
    TradeController(),
  ];
  bool isClient = false;
  bool isZdachi = false;
  bool isSavdodanTushish = false;
  int? isZdachiType;
  int? isZdachiPrice;

  TextEditingController zdachiController = TextEditingController();
  TextEditingController savdodanTushishController = TextEditingController();
  TextEditingController txtDate = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<CustomerCubit>().getCustomer(0, "");
    });
    super.initState();
  }

  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.DEFAULT_PADDING),
      child: Column(
        children: [
          const Hg(),
          const TextWidget(txt: "Sotish"),
          const Hg(),
          TextWidget(
            txt:
                "Savdo xozirda ${_tradeController.length} xil to'lov usulida sotilmoqda",
            textAlign: TextAlign.left,
            size: 16,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        //Client endpoint
                        const Hg(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isClient,
                                  onChanged: (value) {
                                    isClient = value!;

                                    if (isClient == true) customerId = null;
                                    setState(() {});
                                  },
                                ),
                                const TextWidget(
                                  txt: "Mijozga sotish",
                                  size: 12,
                                ),
                              ],
                            ),
                            BlocBuilder<CustomerCubit, CustomerState>(
                              builder: (context, state) {
                                if (state is CustomerLoadingState) {
                                  return const CircularProgressIndicator
                                      .adaptive();
                                } else if (state is CustomerErrorState) {
                                  return TextWidget(txt: state.error);
                                } else if (state is CustomerSuccessState) {
                                  return Visibility(
                                    visible: isClient,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          txt: 'Xaridorni tanlang',
                                          size: 14.sp,
                                        ),
                                        Hg(
                                          height: 8.h,
                                        ),
                                        Container(
                                          height: 40.spMax,
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  1,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                              color: AppColors.borderColor,
                                            ),
                                          ),
                                          child: DropDownTextField(
                                            textFieldDecoration:
                                                InputDecoration(
                                              hintText: "Mijozni tanlang ..",
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: AppColors.primaryColor,
                                            ),
                                            clearOption: true,
                                            textFieldFocusNode:
                                                textFieldFocusNode,
                                            searchFocusNode: searchFocusNode,
                                            dropDownItemCount: 8,
                                            searchShowCursor: false,
                                            enableSearch: true,
                                            textStyle: const TextStyle(
                                                color: Colors.white),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            dropdownColor:
                                                AppColors.primaryColor,
                                            listTextStyle: const TextStyle(
                                                color: Colors.white),
                                            searchAutofocus: true,
                                            searchDecoration:
                                                const InputDecoration(
                                              hintText: "Mijozni qidirish ...",
                                              hintStyle: TextStyle(
                                                  color: Colors.white),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                            ),
                                            dropDownList:
                                                state.data.data.map((value) {
                                              return DropDownValueModel(
                                                value: value.id,
                                                name: value.name ?? '',
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                customerId = value?.value;
                                              });
                                            },
                                          ),

                                          // DropdownButtonHideUnderline(
                                          //   child: DropdownButton(
                                          //     value: customerId,
                                          //     items:
                                          //         state.data.data.map((value) {
                                          //       return DropdownMenuItem(
                                          //         value: value.id,
                                          //         child: Padding(
                                          //           padding:
                                          //               EdgeInsets.symmetric(
                                          //                   horizontal: 16.w),
                                          //           child: TextWidget(
                                          //             txt: value.name,
                                          //             txtColor: Colors.white,
                                          //             size: 14.sp,
                                          //             fontWeight:
                                          //                 FontWeight.w400,
                                          //           ),
                                          //         ),
                                          //       );
                                          //     }).toList(),
                                          //     onChanged: (value) {
                                          //       customerId = value!;
                                          //       customerModel = state.data.data
                                          //           .where((element) =>
                                          //               element.id ==
                                          //               customerId)
                                          //           .toList()
                                          //           .first;
                                          //       setState(() {});
                                          //     },
                                          //     isExpanded: true,
                                          //     hint: Padding(
                                          //       padding: EdgeInsets.symmetric(
                                          //           horizontal: 16.w),
                                          //       child: const Text(
                                          //         "Haridorni tanlang",
                                          //         style: TextStyle(
                                          //           color: Colors.white,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     dropdownColor:
                                          //         AppColors.primaryColor,
                                          //   ),
                                          // ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        ),

                        // Zdachi (Qaytim berish endpoint)
                        const Hg(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isZdachi,
                                  onChanged: (value) {
                                    isZdachi = value!;
                                    setState(() {});
                                  },
                                ),
                                const TextWidget(
                                  txt: "Qaytim berish",
                                  size: 12,
                                ),
                              ],
                            ),
                            if (isZdachi)
                              Column(
                                children: [
                                  PostInput(
                                    inputWidth:
                                        MediaQuery.sizeOf(context).width,
                                    controller: zdachiController,
                                    label: 'Narxi',
                                    txtColor: Colors.white,
                                    widht: 0,
                                  ),
                                  BlocBuilder<TypesCubit, TypesState>(
                                    builder: (context, state) {
                                      if (state is TypesLoadingState) {
                                        return const CircularProgressIndicator
                                            .adaptive();
                                      } else if (state is TypesErrorState) {
                                        return TextWidget(txt: state.error);
                                      } else if (state is TypesSuccessState) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              txt: 'Savdo turi',
                                              size: 14.sp,
                                            ),
                                            Hg(
                                              height: 8.h,
                                            ),
                                            Container(
                                              height: 40.spMax,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                border: Border.all(
                                                  color: AppColors.borderColor,
                                                ),
                                              ),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  value: isZdachiType,
                                                  items:
                                                      state.data.map((value) {
                                                    return DropdownMenuItem(
                                                      value: value.id,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    16.w),
                                                        child: TextWidget(
                                                          txt: value.name,
                                                          txtColor:
                                                              Colors.white,
                                                          size: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    isZdachiType = value!;

                                                    setState(() {});
                                                  },
                                                  isExpanded: true,
                                                  hint: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.w),
                                                    child: const Text(
                                                      "Pul turini tanlang",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  dropdownColor:
                                                      AppColors.primaryColor,
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
                                  BlocBuilder<PriceCubit, PriceState>(
                                    builder: (context, state) {
                                      if (state is PriceLoadingState) {
                                        return const CircularProgressIndicator
                                            .adaptive();
                                      } else if (state is PriceErrorState) {
                                        return TextWidget(txt: state.error);
                                      } else if (state is PriceSuccessState) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  1,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                border: Border.all(
                                                  color: AppColors.borderColor,
                                                ),
                                              ),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  value: isZdachiPrice,
                                                  items:
                                                      state.data.map((value) {
                                                    return DropdownMenuItem(
                                                      value: value.id,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    16.w),
                                                        child: TextWidget(
                                                          txt: value.name,
                                                          txtColor:
                                                              Colors.white,
                                                          size: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    isZdachiPrice = value!;

                                                    setState(() {});
                                                  },
                                                  isExpanded: true,
                                                  hint: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.w),
                                                    child: const Text(
                                                      "Savdo turini tanlang",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  dropdownColor:
                                                      AppColors.primaryColor,
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
                                ],
                              )
                          ],
                        ),

                        if (!isZdachi && !isClient)
                          Expanded(
                            child: Image.asset(
                              "assets/logo.png",
                              fit: BoxFit.fitWidth,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Hg(),
                      Expanded(
                          child: SingleChildScrollView(child: buildListView())),
                      const Hg(),
                      addTile(),
                      const Hg(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              label: "Bekor qilish",
                              icon: Icons.exit_to_app,
                              color: AppColors.primaryColor,
                              onTap: () {
                                Get.back();
                              },
                            ),
                          ),
                          const Wd(),
                          Expanded(
                            child: ButtonWidget(
                              icon: Icons.print,
                              label: "Sotish",
                              color: AppColors.primaryColor,
                              onTap: () {
                                _handleButtonTap();
                              },
                            ),
                          ),
                          BlocListener<BasketCubit, BasketState>(
                            listener: (context, state) {
                              if (state is BasketSuccessCheck) {
                                if (state.checkId.isNotEmpty) {
                                  if (kDebugMode) {
                                    print('Check ID: ${state.checkId}');
                                  }
                                  // printAwesomeSalesCheck(
                                  //   widget.products,
                                  //   customerModel == null
                                  //       ? "Xaridorsiz savdo"
                                  //       : customerModel!.name ??
                                  //           "Xaridorsiz savdo",
                                  //   customerModel == null
                                  //       ? ""
                                  //       : customerModel!.phone ?? "",
                                  //   state.checkId,
                                  //   dataa,
                                  //   isZdachiType,
                                  //   isZdachiPrice,
                                  //   double.tryParse(zdachiController.text),
                                  //   txtDate.text,
                                  //   comment,
                                  // );
                                  printSalesCheck(
                                    context,
                                    widget.products,
                                    AppConstants.currentBranchUser,
                                    customerModel!.name.toString(),
                                    int.parse(state.checkId),
                                  );

                                  // generateAndPrintPdf(
                                  //     widget.products,
                                  //     customerModel == null
                                  //         ? "Xaridorsiz savdo"
                                  //         : customerModel!.name ??
                                  //             "Xaridorsiz savdo",
                                  //     customerModel == null
                                  //         ? ""
                                  //         : customerModel!.phone ?? "",
                                  //     state.checkId,
                                  //     dataa,
                                  //     isZdachiType,
                                  //     isZdachiPrice,
                                  //     double.tryParse(zdachiController.text),
                                  //     txtDate.text,
                                  //     comment);
                                  Get.back();
                                }
                              }
                            },
                            child: const SizedBox(),
                          ),
                        ],
                      ),
                      const Hg()
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<SavedBasketModel> dataa = [];
  String? comment;

  void _handleButtonTap() async {
    for (int i = 0; i < _tradeController.length; i++) {
      comment = _tradeController[i].commentController.text;
      dataa.add(
        SavedBasketModel(
          priceId: _tradeController[i].moneyFormSelected!,
          price: double.parse(
            _tradeController[i].txtPrice.text.replaceAll(" ", ""),
          ),
          typeId: _tradeController[i].tradeType!,
          customerId: customerId,
        ),
      );
    }

    try {
      context.read<BasketCubit>().saveBasket(
            dataa,
            isZdachi ? double.parse(zdachiController.text) : null,
            isZdachiPrice,
            isZdachiType,
            comment,
          );
    } catch (e) {
      // Handle exception
      if (kDebugMode) {
        print('Exception: $e');
      }
    }
  }

  void _removeGroup(int index) {
    deletedDialog(context, () {
      setState(() {
        _tradeController.removeAt(index);

        Get.back();
      });
    });
  }

  Widget addTile() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tradeController.add(TradeController());
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        width: 85.w,
        child: Center(
          child: Icon(
            Icons.add,
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }

  Future<void> selectDate() async {
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialEntryMode: DatePickerEntryMode.calendarOnly);

    if (picker != null) {
      setState(() {
        txtDate.text = picker.toString().split(" ")[0];
      });
    }
  }

  Widget buildListView() {
    List<Widget> children = [
      for (int i = 0; i < _tradeController.length; i++)
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              BlocBuilder<TypesCubit, TypesState>(
                builder: (context, state) {
                  if (state is TypesLoadingState) {
                    return const CircularProgressIndicator.adaptive();
                  } else if (state is TypesErrorState) {
                    return TextWidget(txt: state.error);
                  } else if (state is TypesSuccessState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          txt: 'Savdo turi',
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
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.borderColor,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: _tradeController[i].tradeType,
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
                                _tradeController[i].tradeType = value!;

                                print(_tradeController[i].tradeType);
                                setState(() {});
                              },
                              isExpanded: true,
                              hint: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: const Text(
                                  "Pul turini tanlang",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              dropdownColor: AppColors.primaryColor,
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
                          width: MediaQuery.sizeOf(context).width / 1,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.borderColor,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: _tradeController[i].moneyFormSelected,
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
                                _tradeController[i].moneyFormSelected = value!;
                                if (_tradeController[i].moneyFormSelected ==
                                    2) {
                                  _tradeController[i].txtPrice.text =
                                      widget.dollarPirce.toStringAsFixed(2);
                                } else {
                                  _tradeController[i].txtPrice.text =
                                      widget.somPrice.toStringAsFixed(2);
                                }
                                setState(() {});
                              },
                              isExpanded: true,
                              hint: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: const Text(
                                  "Savdo turini tanlang",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              dropdownColor: AppColors.primaryColor,
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
              _tradeController[i].tradeType == 4
                  ? PostInput(
                      inputWidth: MediaQuery.sizeOf(context).width,
                      controller: txtDate,
                      hintText: "Sanani tanlang",
                      mainAxisAlignment: MainAxisAlignment.center,
                      visible: false,
                      onTap: () {
                        selectDate();
                      },
                      label: "To'lash sanani tanlang",
                      suffixIcon: const Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(),
              _tradeController[i].tradeType == 4
                  ? Hg(
                      height: 20,
                    )
                  : SizedBox(),
              _tradeController[i].tradeType == 4
                  ? PostInput(
                      inputWidth: MediaQuery.sizeOf(context).width,
                      controller: _tradeController[i].commentController,
                      hintText: "Izoh kiriting",
                      mainAxisAlignment: MainAxisAlignment.center,
                      visible: false,
                      label: "",
                      suffixIcon: const Icon(
                        Icons.edit_note,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(),
              Hg(),
              _tradeController[i].moneyFormSelected == 1
                  ? PostInput(
                      inputWidth: MediaQuery.sizeOf(context).width,
                      controller: _tradeController[i].txtPrice,
                      label: 'Narxi',
                      txtColor: Colors.white,
                      widht: 0,
                    )
                  : _tradeController[i].moneyFormSelected == 2
                      ? PostInput(
                          inputWidth: MediaQuery.sizeOf(context).width,
                          controller: _tradeController[i].txtPrice,
                          label: 'Narx',
                          txtColor: Colors.white,
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(
                              RegExp(
                                r'^\d*\.?\d*$',
                              ),
                            ), //
                          ],
                          widht: 0,
                        )
                      : const SizedBox(),
              const Hg(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  _removeGroup(i);
                },
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          TextWidget(txt: "O'chirish")
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
    ];
    return SingleChildScrollView(
      primary: false,
      child: Column(
        children: children,
      ),
    );
  }
}

class TradeController {
  TextEditingController txtPrice = TextEditingController();
  TextEditingController commentController = TextEditingController();
  int? moneyFormSelected;
  int? tradeType;
}
