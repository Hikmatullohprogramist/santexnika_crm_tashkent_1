import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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

class StoreAddWidget extends StatefulWidget {
  const StoreAddWidget({super.key});

  @override
  State<StoreAddWidget> createState() => _StoreAddWidgetState();
}

class _StoreAddWidgetState extends State<StoreAddWidget> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            TextWidget(txt: "Mahsulot qo'shish"),
            Hg(),
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
                      return const TextWidget(txt: postError);
                    } else if (state is CategorySuccessState) {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                txt: 'Kategoriya',
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: DropDownTextField(
                                    textFieldDecoration: InputDecoration(
                                      suffixIcon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      hintText: "Kategoriyani kiriting..",
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.primaryColor,
                                    ),
                                    clearOption: true,
                                    textFieldFocusNode: textFieldFocusNode,
                                    searchFocusNode: searchFocusNode,
                                    dropDownItemCount: 8,
                                    searchShowCursor: false,
                                    enableSearch: true,
                                    searchKeyboardType: TextInputType.number,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    dropdownColor: AppColors.primaryColor,
                                    listTextStyle:
                                        const TextStyle(color: Colors.white),
                                    searchAutofocus: true,
                                    searchDecoration: const InputDecoration(
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    dropDownList: state.data.data.map((value) {
                                      return DropDownValueModel(
                                        value: value.id,
                                        name: value.name ?? '',
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        categoryVaule = value?.value;
                                      });
                                    },
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
                    label: "Olish narxi",
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
                    keyboardType: TextInputType.number,
                    label: "Bahosi",
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
                            RegExp(r'^\d*\.?\d*'),
                          ),
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
                        child: productImage == null
                            ? const Icon(
                                Icons.no_accounts,
                                size: 50,
                              )
                            : Image.file(
                                File(
                                  productImage!.path!,
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
                    label: "Ogohlantiruvchi miqdor",
                    keyboardType: TextInputType.number,
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
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'^\d*\.?\d*$',
                        ),
                      ), // Allow only numbers
                    ],
                    controller: txtTotalPrice,
                    label: "Optom narx",
                  ),
                ),
              ],
            ),
            // Hg(
            //   height: 20.h,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Expanded(
            //       child: DropdownSearch<ProductModel>(
            //
            //       ),
            //     ),
            //   ],
            // ),
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
                      txtDangerCount.text.isEmpty ||
                      txtTotalPrice.text.isEmpty) {
                    errorDialogWidgets(context);
                    return;
                  }

                  context
                      .read<StoreCubit>()
                      .postProduct(
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
                      .then(
                    (value) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((timeStamp) async {
                        context
                            .read<StoreCubit>()
                            .getProductDesktop(1, "")
                            .then((_) {
                          Navigator.of(context).pop(); // Close the dialog
                        }).catchError((error) {
                          print(error);
                        });
                      });
                    },
                  );
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

      // Split the result into integer and decimal parts
      List<String> parts = increasedNumber.toString().split('.');
      String integerPart = parts[0];
      String decimalPart = parts.length > 1 ? parts[1] : '';

      // Take the first two digits after the decimal point
      if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }

      // Combine the integer and decimal parts
      String formattedResult =
          integerPart + (decimalPart.isNotEmpty ? '.$decimalPart' : '');

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
