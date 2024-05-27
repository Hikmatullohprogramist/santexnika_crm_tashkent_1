import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/screens/settings/cubit/price/price_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/types/types_cubit.dart';

import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';
import 'package:santexnika_crm/widgets/mobile/one_button.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../../models/orders/orderWithIdModel.dart';
import '../../../../../models/orders/transfer2storeModel.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../returned_ones/cubit/returned_store_cubit.dart';
import '../../../cubit/sold_cubit.dart';

class MobileTakeBackDialog extends StatefulWidget {
  final List<Basket> selectedProducts;
  final List<Basket> data;
  final VoidCallback onTap;
  final int id;

  const MobileTakeBackDialog(
      {super.key,
      required this.selectedProducts,
      required this.data,
      required this.onTap,
      required this.id, });

  @override
  State<MobileTakeBackDialog> createState() => _MobileTakeBackDialogState();
}

class _MobileTakeBackDialogState extends State<MobileTakeBackDialog> {
  List<Basket> readyProducts = [];

  final Map<int, TextEditingController> _controllersAmount = {};
  final Map<int, TextEditingController> _controllersComment = {};

  void _initControllers() {
    widget.selectedProducts.asMap().forEach(
      (index, product) {
        _controllersAmount[index] ??= TextEditingController(text: "");
        _controllersComment[index] ??= TextEditingController(text: "");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _controllersComment.forEach((key, controller) => controller.dispose());
    _controllersAmount.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  int? selectedPrice;
  int? selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: TextWidget(txt: "Chek raqami: ${widget.id ?? 0}"),
        leading: IconButton(
          onPressed: widget.onTap,
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TextWidget(txt: "Qaytib olish"),
            const Hg(),
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
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: AppColors.borderColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedType,
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
                              selectedType = value!;

                              print("SELECTED TYPE ID + $selectedType");
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
            const Hg(),
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
                        txt: 'Savdo turi',
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
                            value: selectedPrice,
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
                              selectedPrice = value!;

                              print("SELECTED PRICE ID + $selectedPrice");

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
            const Hg(),
            Expanded(
              child: widget.selectedProducts.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.selectedProducts.length,
                      itemBuilder: (context, index) {
                        var data = widget.selectedProducts[index];

                        _controllersAmount[index]?.text = data.quantity;
                        _controllersComment[index] ??=
                            TextEditingController(text: "");
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: MobileBackgroundWidget(
                            color: AppColors.toqPrimaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  txt: 'Nomi: ${data.store.name}',
                                  elips: true,
                                ),
                                const Hg(),
                                TextWidget(
                                  txt:
                                      "Savdodagi miqdori ${data.quantity ?? 0}",
                                  elips: true,
                                ),
                                const Hg(),
                                MobileInput(
                                  color: AppColors.primaryColor,
                                  controller: _controllersAmount[index],
                                  label: "Soni",
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  inputFormatter: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*'),
                                    ),
                                  ],
                                ),
                                const Hg(),
                                MobileInput(
                                  color: AppColors.primaryColor,
                                  label: "Izoh",
                                  controller: _controllersComment[index],
                                ),
                                const Hg(),
                                OneButton(
                                  width: double.infinity,
                                  label: "O'chirish",
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppColors.errorColor,
                                  ),
                                  onTap: () {
                                    mobileDeletedDialog(
                                      context,
                                      () {
                                        setState(
                                          () {
                                            widget.selectedProducts
                                                .remove(data);
                                            Get.back();
                                          },
                                        );
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const TextWidget(txt: empty),
            ),
            Hg(height: 4,),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: OneButton(
                  width: double.infinity,
                  onTap: () async {
                    List<Transfer2StoreModel> readyProducts =
                        widget.selectedProducts.asMap().entries.map((entry) {
                      int index = entry.key;
                      var product = entry.value;
                      TextEditingController amountController =
                          _controllersAmount[index]!;
                      TextEditingController commentController =
                          _controllersComment[index]!;

                      double quantity =
                          double.tryParse(amountController.text.trim()) ?? 0;

                      return Transfer2StoreModel(
                        storeId: product.storeId,
                        orderId: product.orderId,
                        quantity: quantity,
                        comment: commentController.text == ""
                            ? "Commentariya yozilmagan"
                            : commentController.text.trim(),
                      );
                    }).toList();
                    print('object');
                    if (selectedType != null && selectedPrice != null) {
                      await context
                          .read<ReturnedStoreCubit>()
                          .postReturnedStore(
                            readyProducts,
                            selectedPrice!,
                            selectedType!,
                          );
                      widget.selectedProducts.clear();
                      context.read<SoldCubit>().getSoldWithId(0, widget.id!);

                      Navigator.pop(context);
                    } else {
                      errorDialogWidgets(context);
                    }
                  },
                  label: "Tasdiqlash",
                  icon: Icon(
                    Icons.done_all,
                    color: AppColors.selectedColor,
                    size: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
