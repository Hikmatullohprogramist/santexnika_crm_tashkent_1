// ignore_for_file: unnecessary_question_mark

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/screens/settings/cubit/category/category_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/price/price_cubit.dart';
import 'package:santexnika_crm/screens/store/cubit/store_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../../settings/settings_desktop/add_widgets/category.dart';

class StoreUpdateWidget extends StatefulWidget {
  final int id;
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
  final String? search;
  final int? currentPage;

  const StoreUpdateWidget({
    super.key,
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
    required this.id,
    this.image,
    this.search,
    this.currentPage,
  });

  @override
  State<StoreUpdateWidget> createState() => _StoreAddWidgetState();
}

class _StoreAddWidgetState extends State<StoreUpdateWidget> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtComePrice = TextEditingController();
  TextEditingController txtFoiz = TextEditingController();
  TextEditingController txtOEM = TextEditingController();
  TextEditingController txtPriceSell = TextEditingController();
  TextEditingController txtBarCode = TextEditingController();
  TextEditingController txtQuantity = TextEditingController();
  TextEditingController txtDangerCount = TextEditingController();
  TextEditingController txtTotalPrice = TextEditingController();
  int? selectedValuee;
  int? categoryVaule;

  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PostInput(
                    controller: txtName,
                    label: "Nomi",
                  ),
                ),
                Wd(
                  width: 20.w,
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
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.white),
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
                                        const AddCategoryWidgets(),
                                        3,
                                        2.8,
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
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
            Hg(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: PostInput(
                    controller: txtComePrice,
                    label: "Olish Narx",
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
                ),
                Wd(
                  width: 20.w,
                ),
                BlocBuilder<PriceCubit, PriceState>(
                  builder: (context, state) {
                    if (state is PriceLoadingState) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (state is PriceErrorState) {
                      return const TextWidget(txt: postError);
                    } else if (state is PriceSuccessState) {
                      return Expanded(
                        child: Column(
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
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
            Hg(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: PostInput(
                    controller: txtFoiz,
                    label: "Foiz",
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'^\d*\.?\d*$',
                        ),
                      ), // Allow only numbers
                    ],
                    onChanged: (value) {
                      calculate();
                    },
                  ),
                ),
                Wd(
                  width: 20.w,
                ),
                Expanded(
                  child: PostInput(
                    controller: txtPriceSell,
                    inputWidth: double.infinity,
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
                ),
              ],
            ),
            Hg(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PostInput(
                        controller: txtOEM,
                        label: "OEM",
                      ),
                      Hg(
                        height: 20.h,
                      ),
                      PostInput(
                        controller: txtQuantity,
                        label: "Soni",
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                            RegExp(
                              r'^\d*\.?\d*$',
                            ),
                          ), // Allow only numbers
                        ],
                      ),
                    ],
                  ),
                ),
                Wd(
                  width: 20.w,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      getProductImage();
                    },
                    child: Container(
                      width: 250.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: widget.image == null
                            ? const Icon(
                                Icons.no_accounts,
                                size: 50,
                              )
                            : Image.file(
                                File(
                                  widget.image!.path!,
                                ),
                              ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Hg(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: PostInput(
                    controller: txtDangerCount,
                    label: "Ogahlantiruvchi miqdor",
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
                ),
                Wd(
                  width: 20.w,
                ),
                Expanded(
                  child: PostInput(
                    controller: txtTotalPrice,
                    label: "Optom narx",
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
                ),
              ],
            ),
            Hg(
              height: 20.h,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: ButtonWidget(
                width: 200.w,
                icon: Icons.exit_to_app,
                label: "Bekor qilish",
                color: AppColors.primaryColor,
                onTap: () {
                  Get.back();
                },
              ),
            ),
            const Wd(),
            Expanded(
              flex: 3,
              child: ButtonWidget(
                width: 200.w,
                icon: Icons.save,
                label: "Saqlash",
                color: AppColors.primaryColor,
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

                  context
                      .read<StoreCubit>()
                      .updateProduct(
                        widget.id,
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
                      )
                      .then((value) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((timeStamp) async {
                      if (widget.search != "" && widget.search != null) {
                        context.read<StoreCubit>().searchProduct(
                            widget.search!, widget.currentPage ?? 1);
                      } else {
                        context.read<StoreCubit>().getProductDesktop(widget.currentPage ?? 1, "");
                      }

                      Navigator.of(context).pop(); // Close the dialog
                    });
                  }).catchError((error) {
                    print(error);
                  });
                },
              ),
            ),
          ],
        ),
      ],
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
      String formattedResult = increasedNumber.toStringAsFixed(1);

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
