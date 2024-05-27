import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/models/orders/orderWithIdModel.dart';
import 'package:santexnika_crm/models/orders/transfer2storeModel.dart';
import 'package:santexnika_crm/screens/returned_ones/cubit/returned_store_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/price/price_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/types/types_cubit.dart';
import 'package:santexnika_crm/screens/sold/cubit/sold_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class Transfer2Store extends StatefulWidget {
  final List<dynamic> selectedProducts;
  final Function()? funk;

  const Transfer2Store({
    super.key,
    required this.selectedProducts,
    this.funk,
  });

  @override
  State<Transfer2Store> createState() => _Transfer2StoreState();
}

class _Transfer2StoreState extends State<Transfer2Store> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Align(
            alignment: Alignment.center,
            child: TextWidget(
              txt: "Omborga qaytarish",
            )),
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
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
        const Hg(
          height: 20,
        ),
        const Hg(),
        Expanded(
          child: widget.selectedProducts.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.selectedProducts.length,
                  itemBuilder: (ctx, index) {
                    var data = widget.selectedProducts[index];

                    _controllersAmount[index]?.text = data.quantity.toString();
                    _controllersComment[index] ??=
                        TextEditingController(text: "");

                    return Card(
                      color: AppColors.toqPrimaryColor,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  txt: "${data.store.name}",
                                  txtColor: AppColors.whiteColor,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextWidget(
                                      txt:
                                          "Savdodagi miqdori ${data.quantity} /",
                                      txtColor: AppColors.whiteColor,
                                    ),
                                    const Wd(),
                                    PostInput(
                                      label: "Soni",
                                      controller: _controllersAmount[index],
                                      // Use the controller for this index

                                      txtColor: AppColors.whiteColor,
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
                                  ],
                                ),
                                const Hg(),
                                PostInput(
                                  label: "Kamentariya",
                                  controller: _controllersComment[index],
                                  txtColor: AppColors.whiteColor,
                                ),
                              ],
                            ),
                            ButtonWidget(
                              radius: 12,
                              color: AppColors.primaryColor,
                              label: "O'chirish",
                              height: 60.h,
                              fontSize: 16.sp,
                              width: 200.w,
                              iconSize: 32,
                              icon: Icons.remove_circle,
                              onTap: () {
                                widget.selectedProducts.remove(data);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  })
              : const Center(
                  child: TextWidget(txt: "Tovarlar hali tanlanmadi !")),
        ),
        const Hg(),
        ButtonWidget(
            radius: 12,
            color: AppColors.primaryColor,
            label: "Tasdiqlash",
            height: 60.h,
            fontSize: 16.sp,
            iconSize: 32,
            icon: Icons.done_all,
            iconColor: AppColors.successColor,
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

              if (selectedType != null && selectedPrice != null) {
                await context
                    .read<ReturnedStoreCubit>()
                    .postReturnedStore(
                        readyProducts, selectedPrice!, selectedType!)
                    .then(
                  (value) {
                    widget.funk == null ? () {} : widget.funk!();
                    Navigator.of(context).pop();
                  },
                );
              } else {
                errorDialogWidgets(context);
              }
            }),
        const Hg(),
      ],
    );
  }
}
