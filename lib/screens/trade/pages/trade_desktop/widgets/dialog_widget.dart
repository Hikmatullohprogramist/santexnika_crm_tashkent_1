import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:santexnika_crm/models/pruduct/productModel.dart';
import 'package:santexnika_crm/screens/store/branch_access_widget.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_cubit.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';

import '../../../../../models/basket/productsAddModel.dart';
import '../../../../../tools/appColors.dart';
import '../../../../../tools/money_formatter.dart';
import '../../../../../widgets/data_table.dart';
import '../../../../../widgets/input/post_input.dart';
import '../../../../../widgets/my_dialog_widget.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/data_culumn_text.dart';
import '../../../../../widgets/text_widget/data_row_text.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../../store/cubit/store_cubit.dart';
import '../../../../store/pages/desktop/store_desktop/widget/update.dart';
import 'package:get/get.dart';

class TradeDialogWidget extends StatefulWidget {
  const TradeDialogWidget({super.key});

  @override
  State<TradeDialogWidget> createState() => _TradeDialogWidgetState();
}

class _TradeDialogWidgetState extends State<TradeDialogWidget> {
  List<ProductsAddModel> selectedProduct = [];
  int currentPage = 0;

  void onSelectedRow(bool selected, ProductsAddModel model) {
    setState(() {
      print("Product ID: ${model.productId}");
      print("Selected: $selected");
      print(
          "Quantity: ${model.quantity} (Type: ${model.quantity.runtimeType})");

      if (selected) {
        // Ensure quantity is an integer
        int? quantity = model.quantity is String
            ? int.parse(model.quantity.toString())
            : model.quantity;
        print("Parsed Quantity: $quantity");

        if (quantity! >= 1 &&
            !selectedProduct
                .any((element) => element.productId == model.productId)) {
          selectedProduct.add(model);
          print("Product added: ${model.productId}");
        }
      } else {
        // Remove if in the list
        selectedProduct
            .removeWhere((element) => element.productId == model.productId);
      }
    });
  }

  Timer? _searchTimer;

  void handleSearch(String query) {
    if (mounted) {
      _searchTimer?.cancel(); // Cancel the existing timer if it exists

      _searchTimer = Timer(
        const Duration(milliseconds: 600),
        () {
          if (query.isNotEmpty) {
            searchQuery = query;
            currentPage = 0;
            context.read<StoreCubit>().searchProduct(query.trim());
          } else {
            context.read<StoreCubit>().getProduct(1, "");
            searchQuery = "";
          }
        },
      );
    }
  }

  String searchQuery = "";

  void selectedProductIsDeleted(ProductModel data) {
    if (selectedProduct.any((element) => element.productId == data.id)) {
      // Print whether the selectedProduct contains the productModel

      // Remove the productModel from the selectedProduct list
      selectedProduct.removeWhere(
        (element) => element.productId == data.id,
      );

      // Update the UI
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: AppColors.bottombarColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 50,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  txt: 'Ombordagi mahsulotlar',
                ),
              ],
            ),
          ),
          PostInput(
            radius: 8.r,
            inputWidth: double.infinity,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onChanged: (query) {
              handleSearch(query);
            },
          ),
          const Hg(),
          BlocBuilder<StoreCubit, StoreState>(
            builder: (context, state) {
              print(state);
              if (state is StoreLoadingState) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state is StoreErrorState) {
                return TextWidget(
                  txt: state.error,
                  txtColor: Colors.white,
                );
              } else if (state is StoreSuccessState) {
                int totalPages = 0;

                if (state.data.perPage != 0 && state.data.total.isFinite) {
                  totalPages = (state.data.total / state.data.perPage).ceil();
                }
                return Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: AppColors.primaryColor,
                      width: double.infinity,
                      child: Column(
                        children: [
                          DataTableWidget(
                            isHorizantal: true,
                            checkbox: true,
                            dataColumn: [
                              DataColumn(
                                label: SizedBox(
                                  width: MediaQuery.of(context).size.width / 20,
                                  child: const DataColumnText(
                                    txt: 'Nomi',
                                  ),
                                ),
                              ),
                              const DataColumn(
                                label: DataColumnText(
                                  txt: 'Kategory',
                                ),
                              ),
                              const DataColumn(
                                  label: DataColumnText(
                                txt: 'Miqdor',
                              )),
                              const DataColumn(
                                  label: DataColumnText(txt: 'Kelgan narxi')),
                              const DataColumn(
                                  label: DataColumnText(txt: 'Sotish narxi')),
                              const DataColumn(
                                  label: DataColumnText(txt: 'Shtrix kod')),
                              const DataColumn(
                                  label: DataColumnText(txt: 'Pul turi')),
                              const DataColumn(
                                  label: DataColumnText(txt: 'OEM')),
                              const DataColumn(label: DataColumnText(txt: '')),
                            ],
                            dataRow:
                                List.generate(state.data.data.length, (index) {
                              var data = state.data.data[index];
                              var quantityValue =
                                  double.tryParse(data.quantity.toString()) ??
                                      0;
                              var productModel = ProductsAddModel(
                                quantity: quantityValue >= 1 ? 1 : 0,
                                productId: data.id!,
                              );

                              return DataRow(
                                onSelectChanged: (bool? selected) {
                                  if (selected != null) {
                                    onSelectedRow(selected, productModel);
                                  }
                                },
                                selected: selectedProduct.any(
                                    (element) => element.productId == data.id),
                                cells: [
                                  DataCell(
                                    DataRowText(
                                      txt: data.name?.toString() ?? 'N/A',
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: data.category!.name?.toString() ??
                                          'N/A',
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatterWidthDollor(
                                            double.parse(
                                              data.quantity.toString(),
                                            ),
                                          ) ??
                                          'N/A',
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatterWidthDollor(
                                        double.parse(
                                          data.priceCome.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatterWidthDollor(
                                        double.parse(
                                          data.priceSell.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatter(
                                        double.parse(
                                          data.barcode.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt:
                                          data.price!.name?.toString() ?? 'N/A',
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: data.madeIn?.toString() ?? 'N/A',
                                    ),
                                  ),
                                  DataCell(
                                    BranchAccessEditAndDelete(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showCustomDialogWidget(
                                                context,
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextWidget(
                                                      txt: "O'chirish",
                                                      txtColor: Colors.red,
                                                      size: 24.sp,
                                                    ),
                                                    const TextWidget(
                                                      txt:
                                                          "Rostdan ham o`chirmoqchimisiz?",
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: ButtonWidget(
                                                            color: AppColors
                                                                .primaryColor,
                                                            isVisible: false,
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            label:
                                                                'Bekor qilish',
                                                          ),
                                                        ),
                                                        const Wd(),
                                                        Expanded(
                                                          child: ButtonWidget(
                                                            color: AppColors
                                                                .primaryColor,
                                                            isVisible: false,
                                                            onTap: () {
                                                              context
                                                                  .read<
                                                                      StoreCubit>()
                                                                  .deleteProduct(
                                                                [data.id!],
                                                              ).then((value) {
                                                                WidgetsBinding
                                                                    .instance
                                                                    .addPostFrameCallback(
                                                                        (timeStamp) async {
                                                                  if (searchQuery
                                                                      .isNotEmpty) {
                                                                    context
                                                                        .read<
                                                                            StoreCubit>()
                                                                        .searchProduct(
                                                                            searchQuery);
                                                                  } else {
                                                                    context
                                                                        .read<
                                                                            StoreCubit>()
                                                                        .getProductDesktop(
                                                                            currentPage,
                                                                            searchQuery);
                                                                  }

                                                                  selectedProductIsDeleted(
                                                                      data);
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              });
                                                            },
                                                            label: "O'chrish",
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                5,
                                                5,
                                              );
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Wd(),
                                          InkWell(
                                            onTap: () {
                                              showCustomDialogWidget(
                                                context,
                                                StoreUpdateWidget(
                                                  search: searchQuery,
                                                  currentPage: currentPage,
                                                  name: data.name,
                                                  comePrice: data.priceCome,
                                                  oem: data.madeIn,
                                                  priceCell: data.priceSell,
                                                  barCode: data.barcode,
                                                  quantity: data.quantity,
                                                  dangerCount: data.dangerCount,
                                                  totalPrice:
                                                      data.priceWholesale,
                                                  categoryVaule:
                                                      data.categoryId,
                                                  selectedValuee: data.priceId,
                                                  // image: data.image,
                                                  id: int.parse(
                                                    data.id.toString(),
                                                  ),
                                                ),
                                                2.5,
                                                1.3,
                                              );
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            color: AppColors.bottombarColor,
                            child: NumberPaginator(
                              initialPage: currentPage,
                              onPageChange: (page) {
                                currentPage = page;

                                context.read<StoreCubit>().getProductDesktop(
                                    currentPage + 1, searchQuery);
                              },
                              numberPages: totalPages,

                              // context.read<StoreCubit>().totalPage,
                              config: NumberPaginatorUIConfig(
                                buttonUnselectedBackgroundColor:
                                    AppColors.bottombarColor,
                                buttonShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                buttonSelectedBackgroundColor:
                                    AppColors.selectedColor,
                                buttonTextStyle:
                                    TextStyle(color: AppColors.whiteColor),
                                buttonUnselectedForegroundColor:
                                    AppColors.whiteColor,
                                mode: ContentDisplayMode.numbers,
                                buttonSelectedForegroundColor:
                                    AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is StoreSearchSuccessState) {
                int totalPages = 0;

                if (state.data.perPage != 0 && state.data.total.isFinite) {
                  totalPages = (state.data.total / state.data.perPage).ceil();
                }
                return Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: AppColors.primaryColor,
                      width: double.infinity,
                      child: Column(
                        children: [
                          DataTableWidget(
                            isHorizantal: true,
                            checkbox: true,
                            dataColumn: [
                              DataColumn(
                                label: SizedBox(
                                  width: MediaQuery.of(context).size.width / 20,
                                  child: const DataColumnText(
                                    txt: 'Nomi',
                                  ),
                                ),
                              ),
                              const DataColumn(
                                label: DataColumnText(
                                  txt: 'Kategory',
                                ),
                              ),
                              const DataColumn(
                                  label: DataColumnText(
                                txt: 'Miqdor',
                              )),
                              const DataColumn(
                                  label: DataColumnText(txt: 'Kelgan narxi')),
                              const DataColumn(
                                  label: DataColumnText(txt: 'Sotish narxi')),
                              const DataColumn(
                                  label: DataColumnText(txt: 'Shtrix kod')),
                              const DataColumn(
                                  label: DataColumnText(txt: 'Pul turi')),
                              const DataColumn(
                                  label: DataColumnText(txt: 'OEM')),
                              const DataColumn(label: DataColumnText(txt: '')),
                            ],
                            dataRow:
                                List.generate(state.data.data.length, (index) {
                              var data = state.data.data[index];
                              var productModel = ProductsAddModel(
                                  quantity:
                                      double.parse(data.quantity.toString()) >=
                                              1
                                          ? 1
                                          : 0,
                                  productId: data.id!);

                              return DataRow(
                                onSelectChanged: (bool? selected) {
                                  if (selected != null) {
                                    onSelectedRow(selected, productModel);
                                  }
                                },
                                selected: selectedProduct.any(
                                    (element) => element.productId == data.id),
                                cells: [
                                  DataCell(
                                    DataRowText(
                                      txt: data.name?.toString() ?? 'N/A',
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: data.category!.name?.toString() ??
                                          'N/A',
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatterWidthDollor(
                                            double.parse(
                                              data.quantity.toString(),
                                            ),
                                          ) ??
                                          'N/A',
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatterWidthDollor(
                                        double.parse(
                                          data.priceCome.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatterWidthDollor(
                                        double.parse(
                                          data.priceSell.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatter(
                                        double.parse(
                                          data.barcode.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt:
                                          data.price!.name?.toString() ?? 'N/A',
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: data.madeIn?.toString() ?? 'N/A',
                                    ),
                                  ),
                                  DataCell(
                                    BranchAccessEditAndDelete(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showCustomDialogWidget(
                                                context,
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextWidget(
                                                      txt: "O'chirish",
                                                      txtColor: Colors.red,
                                                      size: 24.sp,
                                                    ),
                                                    const TextWidget(
                                                      txt:
                                                          "Rostdan ham o`chirmoqchimisiz?",
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: ButtonWidget(
                                                            color: AppColors
                                                                .primaryColor,
                                                            isVisible: false,
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            label:
                                                                'Bekor qilish',
                                                          ),
                                                        ),
                                                        const Wd(),
                                                        Expanded(
                                                          child: ButtonWidget(
                                                            color: AppColors
                                                                .primaryColor,
                                                            isVisible: false,
                                                            onTap: () {
                                                              context
                                                                  .read<
                                                                      StoreCubit>()
                                                                  .deleteProduct(
                                                                [data.id!],
                                                              ).then((value) {
                                                                WidgetsBinding
                                                                    .instance
                                                                    .addPostFrameCallback(
                                                                        (timeStamp) async {
                                                                  if (searchQuery
                                                                      .isNotEmpty) {
                                                                    context
                                                                        .read<
                                                                            StoreCubit>()
                                                                        .searchProduct(
                                                                            searchQuery);
                                                                  } else {
                                                                    context
                                                                        .read<
                                                                            StoreCubit>()
                                                                        .getProductDesktop(
                                                                            currentPage,
                                                                            searchQuery);
                                                                  }
                                                                  selectedProductIsDeleted(
                                                                      data);
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              });
                                                            },
                                                            label: "O'chrish",
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                5,
                                                5,
                                              );
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Wd(),
                                          InkWell(
                                            onTap: () {
                                              showCustomDialogWidget(
                                                context,
                                                StoreUpdateWidget(
                                                  currentPage: currentPage,
                                                  search: searchQuery,
                                                  name: data.name,
                                                  comePrice: data.priceCome,
                                                  oem: data.madeIn,
                                                  priceCell: data.priceSell,
                                                  barCode: data.barcode,
                                                  quantity: data.quantity,
                                                  dangerCount: data.dangerCount,
                                                  totalPrice:
                                                      data.priceWholesale,
                                                  categoryVaule:
                                                      data.categoryId,
                                                  selectedValuee: data.priceId,
                                                  // image: data.image,
                                                  id: int.parse(
                                                    data.id.toString(),
                                                  ),
                                                ),
                                                2.5,
                                                1.3,
                                              );
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            color: AppColors.bottombarColor,
                            child: NumberPaginator(
                              initialPage: currentPage,
                              onPageChange: (page) {
                                currentPage = page;

                                context.read<StoreCubit>().getProductDesktop(
                                    currentPage + 1, searchQuery);
                              },
                              numberPages: totalPages,
                              // context.read<StoreCubit>().totalPage,
                              config: NumberPaginatorUIConfig(
                                buttonUnselectedBackgroundColor:
                                    AppColors.bottombarColor,
                                buttonShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                buttonSelectedBackgroundColor:
                                    AppColors.selectedColor,
                                buttonTextStyle:
                                    TextStyle(color: AppColors.whiteColor),
                                buttonUnselectedForegroundColor:
                                    AppColors.whiteColor,
                                mode: ContentDisplayMode.numbers,
                                buttonSelectedForegroundColor:
                                    AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          const Hg(),
          Container(
            color: AppColors.primaryColor,
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonWidget(
                    width: 200,
                    label: "Bekor qilish",
                    icon: Icons.exit_to_app,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  const Wd(
                    width: 20,
                  ),
                  ButtonWidget(
                    width: 230,
                    label: "Savatga qo'shish ${selectedProduct.length} ta",
                    icon: Icons.save,
                    onTap: () {
                      context
                          .read<BasketCubit>()
                          .postBasket(
                            selectedProduct,
                            1,
                          )
                          .then(
                        (value) {
                          Get.back();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
