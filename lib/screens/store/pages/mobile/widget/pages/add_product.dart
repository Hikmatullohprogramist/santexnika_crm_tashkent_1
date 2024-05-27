import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/settings/cubit/price/price_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/mobile/one_button.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../../../widgets/mobile/mobile_input.dart';
import '../../../../../../widgets/my_dialog_widget.dart';
import '../../../../../../widgets/sized_box.dart';
import '../../../../../settings/cubit/category/category_cubit.dart';
import '../../../../../settings/settings_desktop/add_widgets/category.dart';
import '../../../../../settings/settings_mobile/widgets/category_add.dart';
import '../../../../cubit/store_cubit.dart';

class MobileAddProductUi extends StatefulWidget {
  final int? id;
  final String? name;
  final String? comePrice;
  final String? foiz;
  final String? oem;
  final String? priceCell;
  final String? barCode;
  final String? quantity;
  final String? dangerCount;
  final String? totalPrice;
  final int? categoryVaule;
  final int? selectedValuee;
  final dynamic? image;
  final bool forAdd;

  const MobileAddProductUi(
      {super.key,
      this.id,
      this.name,
      this.comePrice,
      this.foiz,
      this.oem,
      this.priceCell,
      this.barCode,
      this.quantity,
      this.dangerCount,
      this.totalPrice,
      this.categoryVaule,
      this.selectedValuee,
      this.image,
      required this.forAdd});

  @override
  State<MobileAddProductUi> createState() => _MobileAddProductUiState();
}

class _MobileAddProductUiState extends State<MobileAddProductUi> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtComePrice = TextEditingController();
  TextEditingController txtFoiz = TextEditingController();
  TextEditingController txtOEM = TextEditingController();
  TextEditingController txtPriceSell = TextEditingController();
  TextEditingController txtBarCode = TextEditingController();
  TextEditingController txtQuantity = TextEditingController();
  TextEditingController txtDangerCount = TextEditingController();
  TextEditingController txtTotalPrice = TextEditingController();
  TextEditingController txtSearch = TextEditingController();
  int? selectedValuee;
  int? categoryVaule;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  dynamic selectIndex;
  String title = '';

  @override
  void initState() {
    if (widget.forAdd) {
      print('forAdd');
      title = "qo'shish";
    } else {
      txtName.text = widget.name.toString();
      txtComePrice.text = widget.comePrice.toString();
      txtFoiz.text = widget.foiz.toString();
      txtOEM.text = widget.oem.toString();
      txtPriceSell.text = widget.priceCell.toString();
      txtBarCode.text = widget.barCode.toString();
      txtQuantity.text = widget.quantity.toString();
      txtDangerCount.text = widget.dangerCount.toString();
      txtTotalPrice.text = widget.totalPrice.toString();
      selectedValuee = widget.selectedValuee;
      categoryVaule = widget.categoryVaule;
      if (kDebugMode) {
        print(widget.selectedValuee);
      }
      if (kDebugMode) {
        print(widget.categoryVaule);
      }
      title = "o'zgartirish";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: TextWidget(txt: "Omborga $title"),
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Hg(),
                MobileInput(
                  label: "Nomi",
                  controller: txtName,
                  hintText: 'Nomini kiriting...',
                ),
                const Hg(
                  height: 30,
                ),
                BlocBuilder<PriceCubit, PriceState>(
                  builder: (context, state) {
                    if (state is PriceLoadingState) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (state is PriceErrorState) {
                      return  TextWidget(txt: state.error);
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
                const Hg(
                  height: 30,
                ),
                BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoadingState) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (state is CategoryErrorState) {
                      return const Text('Error fetching categories');
                    } else if (state is CategorySuccessState) {
                      if (state.data.data.isEmpty) {
                        return const Text('No categories available');
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kategorya',
                            style: TextStyle(fontSize: 14.sp,color: Colors.white),
                          ),
                          SizedBox(height: 8.h),
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
                                value: categoryVaule,
                                icon: InkWell(
                                  onTap: () {
                                    showCustomDialogWidget(
                                      context,
                                      const MobileCategoryAdd(),
                                      1.1,
                                     3,
                                    );
                                  },
                                  child: const Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                items: state.data.data.map((value) {
                                  return DropdownMenuItem<int>(
                                    value: value.id,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Text(
                                        value.name ?? "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    categoryVaule = value;
                                  });
                                },
                                isExpanded: true,
                                hint: Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 16.w),
                                  child: const Text(
                                    "Select a category",
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
                const Hg(
                  height: 30,
                ),
                MobileInput(
                  controller: txtOEM,
                  hintText: 'oemni kiriting... ',
                  label: "OEM",
                ),
                const Hg(
                  height: 30,
                ),
                MobileInput(
                  controller: txtComePrice,
                  label: "Olish narxi",
                  hintText: 'Olish narxi...',
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
                const Hg(
                  height: 30,
                ),
                MobileInput(
                  controller: txtFoiz,
                  label: "Foiz",
                  hintText: 'Foizni kiriting...',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(
                      RegExp(
                        r'^\d*\.?\d*$',
                      ),
                    ), // Allow only numbers
                  ],
                  onChanged: (v) {
                    calculate();
                  },
                ),
                const Hg(
                  height: 30,
                ),
                MobileInput(
                  controller: txtPriceSell,
                  hintText: 'Bahosini kiriting...',
                  label: "Bahosi",
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
                const Hg(
                  height: 30,
                ),
                MobileInput(
                  controller: txtQuantity,
                  hintText: 'Sonini kiriting...',
                  label: "Soni",
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
                const Hg(
                  height: 30,
                ),
                MobileInput(
                  controller: txtDangerCount,
                  label: "Ogohlantiruvchi miqdor",
                  hintText: 'Ogohlantiruvchi miqdorni kiriting...',
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
                const Hg(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          getProductImage();
                        },
                        child: Container(
                          height: 144,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 2,
                            ),
                          ),
                          child: widget.forAdd
                              ? Center(
                                  child: productImage == null
                                      ? const Icon(
                                          Icons.no_accounts,
                                          size: 50,
                                          color: Colors.white,
                                        )
                                      : Image.file(
                                          File(
                                            productImage!.path!,
                                          ),
                                        ),
                                )
                              : Center(
                                  child: widget.image == null
                                      ? const Icon(
                                          Icons.no_accounts,
                                          size: 50,
                                          color: Colors.white,
                                        )
                                      : Image.file(
                                          File(
                                            widget.image!,
                                          ),
                                        ),
                                ),
                        ),
                      ),
                    ),
                    const Wd(),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OneButton(
                            onTap: () {
                              Get.back();
                            },
                            width: double.infinity,
                            label: "Bekor qilish",
                            icon: const Icon(
                              Icons.remove_circle_outline_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const Hg(
                            height: 30,
                          ),
                          OneButton(
                            onTap: () {
                              if (categoryVaule == null ||
                                  selectedValuee == null ||
                                  txtName.text.isEmpty ||
                                  txtOEM.text.isEmpty ||
                                  txtComePrice.text.isEmpty ||
                                  txtPriceSell.text.isEmpty ||
                                  txtQuantity.text.isEmpty ||
                                  txtDangerCount.text.isEmpty) {
                                errorDialogWidgets(context);
                                return;
                              }

                              if (widget.forAdd) {
                                context.read<StoreCubit>().postProduct(
                                      categoryVaule!,
                                      1,
                                      selectedValuee!,
                                      txtName.text,
                                      txtOEM.text,
                                      txtComePrice.text,
                                      txtPriceSell.text,
                                      txtTotalPrice.text,
                                      txtQuantity.text,
                                      txtDangerCount.text,
                                      productImage,
                                    );
                                Get.back();
                              } else {
                                context.read<StoreCubit>().updateProduct(
                                      widget.id ?? 0,
                                      categoryVaule!,
                                      1,
                                      selectedValuee!,
                                      txtName.text,
                                      txtOEM.text,
                                      txtComePrice.text,
                                      txtPriceSell.text,
                                      txtTotalPrice.text,
                                      txtQuantity.text,
                                      txtDangerCount.text,
                                      productImage,
                                    );
                                Get.back();
                              }
                            },
                            width: double.infinity,
                            label: "Saqlash",
                            color: AppColors.selectedColor,
                            icon: const Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Hg(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculate() {
    String firstText = txtComePrice.text;
    String percentageText = txtFoiz.text;
    if (firstText.isNotEmpty && percentageText.isNotEmpty) {
      double firstNumber = double.parse(firstText);
      double percentage = double.parse(percentageText);

      if (percentageText.isEmpty) {
        txtPriceSell.clear();
      }
      double increasedNumber = firstNumber * (1 + percentage / 100);
      String formattedResult = increasedNumber
          .toStringAsFixed(3)
          .replaceAll(RegExp(r'(\.[1-9]*)0*$'), '');

      txtPriceSell.text = formattedResult;
    } else {
      txtPriceSell.text = '';
    }
  }

  PlatformFile? productImage;

  Future<void> getProductImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'wav',
          'mpeg',
          'mp4',
          'mov',
          'png',
          'jpeg',
        ],
      );

      if (result != null) {
        setState(() {
          productImage = result.files.single;
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error picking document: $error');
      }
    }
  }
}
