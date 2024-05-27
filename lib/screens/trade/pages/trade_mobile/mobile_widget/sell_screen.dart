import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_desktop/widgets/check.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';
import 'package:santexnika_crm/widgets/mobile/one_button.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../../models/basket/basket_model.dart';
import '../../../../../models/basket/save_basket_model.dart';
import '../../../../../models/customer/customerModel.dart';
import '../../../../../tools/appColors.dart';
import '../../../../customer/cubit/customer_cubit.dart';
import '../../../../settings/cubit/price/price_cubit.dart';
import '../../../../settings/cubit/types/types_cubit.dart';
import '../../../cubit/waiting/trade_cubit/basket_cubit.dart';
import '../../../cubit/waiting/trade_cubit/basket_state.dart';
import '../../trade_desktop/widgets/trade_dialog.dart';

class SellMobileUI extends StatefulWidget {
  final List<BasketModel> products;
  final num dollarPirce;
  final num somPrice;

  const SellMobileUI(
      {super.key,
      required this.products,
      required this.dollarPirce,
      required this.somPrice});

  @override
  State<SellMobileUI> createState() => _SellMobileUIState();
}

class _SellMobileUIState extends State<SellMobileUI> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        backgroundColor: AppColors.primaryColor,
        title: const TextWidget(
          txt: "Sotish",
          size: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: AppColors.bottombarColor,
      body: Column(
        children: [
          const Hg(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextWidget(
              txt:
                  "Savdo xozirda ${_tradeController.length} xil to'lov usulida sotilmoqda",
            ),
          ),
          Hg(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                          TextWidget(
                            txt: "Mijozga sotish",
                            size: 14.sp,
                          ),
                        ],
                      ),
                      BlocBuilder<CustomerCubit, CustomerState>(
                        builder: (context, state) {
                          if (state is CustomerLoadingState) {
                            return const CircularProgressIndicator.adaptive();
                          } else if (state is CustomerErrorState) {
                            return TextWidget(txt: state.error);
                          } else if (state is CustomerSuccessState) {
                            return Visibility(
                              visible: isClient,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          MediaQuery.sizeOf(context).width / 1,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: AppColors.borderColor,
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: customerId,
                                          items: state.data.data.map((value) {
                                            return DropdownMenuItem(
                                              value: value.id,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w),
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
                                            customerId = value!;
                                            customerModel = state.data.data
                                                .where((element) =>
                                                    element.id == customerId)
                                                .toList()
                                                .first;
                                            setState(() {});
                                          },
                                          isExpanded: true,
                                          hint: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w),
                                              child: TextWidget(
                                                txt: "Haridorni tanlang ",
                                                size: 15.sp,
                                              )),
                                          dropdownColor: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
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
                  const Hg(
                    height: 5,
                  ),
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
                          TextWidget(
                            txt: "Qaytim berish",
                            size: 14.sp,
                          ),
                        ],
                      ),
                      if (isZdachi)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              MobileInput(
                                label: "Narxi",
                                controller: zdachiController,
                                hintText: '',
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                      r'^\d*\.?\d*$',
                                    ),
                                  ), //
                                ],
                              ),
                              const Hg(),
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
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                              color: AppColors.borderColor,
                                            ),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: isZdachiType,
                                              items: state.data.map((value) {
                                                return DropdownMenuItem(
                                                  value: value.id,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.w),
                                                    child: TextWidget(
                                                      txt: value.name,
                                                      txtColor: Colors.white,
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
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.w),
                                                  child: TextWidget(
                                                    txt:
                                                        "Savdo turini tanlang ",
                                                    size: 15.sp,
                                                  )),
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
                              const Hg(),
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
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: isZdachiPrice,
                                              items: state.data.map((value) {
                                                return DropdownMenuItem(
                                                  value: value.id,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.w),
                                                    child: TextWidget(
                                                      txt: value.name,
                                                      txtColor: Colors.white,
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
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.w),
                                                  child: TextWidget(
                                                    txt: "Pul turini tanlang ",
                                                    size: 15.sp,
                                                  )),
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
                          ),
                        )
                    ],
                  ),
                  buildListView(),
                  Hg(),
                  addTile(),
                  Hg(),
                ],
              ),
            ),
          ),
          BlocListener<BasketCubit, BasketState>(
            listener: (context, state) {
              if (state is BasketSuccessCheck) {
                if (state.checkId.isNotEmpty) {
                  if (kDebugMode) {
                    print('Check ID: ${state.checkId}');
                  }
                  printAwesomeSalesCheck(
                    widget.products,
                    customerModel == null
                        ? "Xaridorsiz savdo"
                        : customerModel!.name ?? "Xaridorsiz savdo",
                    customerModel == null ? "" : customerModel!.phone ?? "",
                    state.checkId,
                    dataa,
                    isZdachiType,
                    isZdachiPrice,
                    double.parse(zdachiController.text),
                    txtDate.text,
                    comment,
                  );
                  Get.back();
                }
              }
            },
            child: const SizedBox(),
          ),
          BlocBuilder<BasketCubit, BasketState>(
            builder: (BuildContext context, BasketState state) {
              if (state is BasketSuccess) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OneButton(
                      progress: state is BasketLoading,
                      width: double.infinity,
                      label: "Sotish",
                      onTap: () {
                        _handleButtonTap();
                        Get.back();
                      },
                      icon: Icon(
                        Icons.print,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
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
          "");
    } catch (e) {
      // Handle exception
      if (kDebugMode) {
        print('Exception: $e');
      }
    }
  }

  void _removeGroup(int index) {
    mobileDeletedDialog(context, () {
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: TextWidget(
                                    txt: "Savdo turini tanlang ",
                                    size: 15.sp,
                                  )),
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: TextWidget(
                                    txt: "Pul turini tanlang ",
                                    size: 15.sp,
                                  )),
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
                  ? MobileInput(
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
                  ? Column(
                      children: [
                        Hg(),
                        MobileInput(
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
                        ),
                      ],
                    )
                  : const SizedBox(),
              Hg(),
              _tradeController[i].moneyFormSelected == 1
                  ? MobileInput(
                      label: "Narxi",
                      controller: _tradeController[i].txtPrice,
                      hintText: '',
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(
                          RegExp(
                            r'^\d*\.?\d*$',
                          ),
                        ), //
                      ],
                    )
                  : _tradeController[i].moneyFormSelected == 2
                      ? MobileInput(
                          label: "Narxi",
                          controller: _tradeController[i].txtPrice,
                          hintText: '',
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(
                              RegExp(
                                r'^\d*\.?\d*$',
                              ),
                            ), //
                          ],
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
}
