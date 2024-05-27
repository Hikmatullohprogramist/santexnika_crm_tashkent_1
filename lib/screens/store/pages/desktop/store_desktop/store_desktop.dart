import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:santexnika_crm/models/pruduct/productModel.dart';
import 'package:santexnika_crm/screens/login/cubit/login_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/branches/branches_cubit.dart';
import 'package:santexnika_crm/screens/store/branch_access_widget.dart';
import 'package:santexnika_crm/screens/store/cubit/store_cubit.dart';
import 'package:santexnika_crm/screens/store/pages/barcode.dart';
import 'package:santexnika_crm/screens/store/pages/desktop/store_desktop/widget/store_add.dart';
import 'package:santexnika_crm/screens/store/pages/desktop/store_desktop/widget/transfer_for_firms.dart';
import 'package:santexnika_crm/screens/store/pages/desktop/store_desktop/widget/transfer_screen.dart';
import 'package:santexnika_crm/screens/store/pages/desktop/store_desktop/widget/update.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/constantas.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/data_table.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/searchble_input.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/snek_bar_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/data_culumn_text.dart';
import 'package:santexnika_crm/widgets/text_widget/data_row_text.dart';

import '../../../../../widgets/text_widget/text_widget.dart';

class StoreDesktopUI extends StatefulWidget {
  const StoreDesktopUI({super.key});

  @override
  State<StoreDesktopUI> createState() => StoreDesktopUIState();
}

class StoreDesktopUIState extends State<StoreDesktopUI> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<StoreCubit>().getProductDesktop(1, "");
    });
    super.initState();
  }

  List<int> selectedProduct = [];
  List<int> selectedProduct1 = [];
  List<ProductModel> selectedProducts = [];
  bool checkBox = false;
  int selectedIndex = 0;
  int currentPage = 0;
  TextEditingController amountController = TextEditingController();

  onSelectedRow(
    bool selected,
    ProductModel model,
  ) {
    setState(() {
      if (selected) {
        selectedProduct.add(model.id!);
        selectedProducts.add(model);
      } else {
        selectedProduct.remove(model.id);
        selectedProducts.remove(model);
      }
    });
  }

  Timer? _searchTimer;

  void handleSearch(String query) {
    if (mounted) {
      _searchTimer?.cancel();

      _searchTimer = Timer(
        const Duration(milliseconds: 600),
        () {
          if (query.isNotEmpty) {
            searchQuery = query;

            currentPage = 0;
            context.read<StoreCubit>().searchProduct(query.trim(), currentPage);
          } else {
            context.read<StoreCubit>().getProduct(1, "");
            searchQuery = "";
          }
        },
      );
    }
  }

  String searchQuery = "";

  Future<void> _showTransferBranch(BuildContext dialogContext) async {
    final result = await showCustomDialogWidgetAsync(
      dialogContext,
      Transfer2Brach(
        selectedProducts: selectedProducts,
        query: searchQuery,
      ),
      1.5,
      1.5,
    );
    print(result);
    if (result == true) {
      print("--------------------------------");
      setState(() {
        selectedProduct.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: AppColors.primaryColor,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [TextWidget(txt: "Ombor")],
              ),
            ),
          ),
          const Hg(
            height: 1,
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderColor,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: SearchInput(
                      onChanged: (query) {
                        handleSearch(query);
                      },
                    ),
                  ),
                  Expanded(
                    child: ButtonWidget(
                      label: "Qo`shish",
                      icon: Icons.add,
                      onTap: () {
                        showCustomDialogWidget(
                          context,
                          const StoreAddWidget(),
                          2.5,
                          1.3,
                        );
                      },
                    ),
                  ),
                  const Wd(),
                  Expanded(
                    child: ButtonWidget(
                      icon: Icons.delete,
                      onTap: () {
                        deletedDialog(
                          context,
                          () {
                            selectedProduct.isNotEmpty
                                ? context
                                    .read<StoreCubit>()
                                    .deleteProduct(selectedProduct)
                                    .then((_) {
                                    if (searchQuery.isNotEmpty) {
                                      if (searchQuery != "") {
                                        context
                                            .read<StoreCubit>()
                                            .searchProduct(searchQuery);
                                      } else {
                                        context
                                            .read<StoreCubit>()
                                            .getProductDesktop(1, "");
                                      }
                                    } else {}
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  }).catchError((error) {
                                    print(error);
                                  })
                                : errorDialogWidgets(context);
                          },
                        );
                      },
                      label: "O'chirish",
                    ),
                  ),
                  const Wd(),
                  selectedProduct.isNotEmpty
                      ? Expanded(
                          child: ButtonWidget(
                            icon: Icons.next_plan_outlined,
                            onTap: () {
                              _showTransferBranch(context);
                            },
                            label: "Filialga o'tkazish",
                          ),
                        )
                      : const SizedBox(),
                  const Wd(),
                  selectedProduct.isNotEmpty
                      ? Expanded(
                          child: ButtonWidget(
                            icon: Icons.next_plan_outlined,
                            onTap: () {
                              showCustomDialogWidget(
                                context,
                                TransferForFirms(
                                  selectedProducts: selectedProducts,
                                  query: searchQuery,
                                ),
                                1.5,
                                1.5,
                              );
                            },
                            label: "Firmaga biriktirish",
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          const Hg(
            height: 3,
          ),
          BlocBuilder<StoreCubit, StoreState>(
            builder: (context, state) {
              if (state is StoreLoadingState) {
                return Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: AppColors.whiteColor,
                  ),
                );
              } else if (state is StoreErrorState) {
                return TextWidget(txt: state.error);
              } else if (state is StoreSuccessState) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.primaryColor),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DataTableWidget(
                            isHorizantal: true,
                            checkbox: true,
                            dataColumn: const [
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Nomi',
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Kategory',
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Miqdor',
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: 'Kelgan narxi'),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: 'Sotish narxi'),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Shtrix kod',
                                ),
                              ),
                              DataColumn(
                                  label: DataColumnText(
                                txt: 'Pul turi',
                              )),
                              DataColumn(
                                label: DataColumnText(txt: 'OEM'),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: ''),
                              ),
                            ],
                            dataRow:
                                List.generate(state.data.data.length, (index) {
                              var data = state.data.data[index];
                              return DataRow(
                                selected: selectedProduct.contains(data.id),
                                onSelectChanged: (value) {
                                  onSelectedRow(value!, data);
                                },
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 7,
                                      child: DataRowText(
                                        txt: data.name?.toString() ?? 'N/A',
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                        txt: data.category!.name?.toString() ??
                                            'N/A',
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    DataRowText(
                                        txt: moneyFormatterWidthDollor(
                                              double.parse(
                                                data.quantity.toString(),
                                              ),
                                            ) ??
                                            'N/A',
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txtColor:
                                          double.parse(data.dangerCount!) >=
                                                  double.parse(data.quantity!)
                                              ? Colors.red[300]
                                              : null,
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
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    DataRowText(
                                        txt: moneyFormatter(
                                          double.parse(
                                            data.barcode.toString(),
                                          ),
                                        ),
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    DataRowText(
                                        txt: data.price!.name?.toString() ??
                                            'N/A',
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    DataRowText(
                                        txt: data.madeIn?.toString() ?? 'N/A',
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
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
                                                              child:
                                                                  ButtonWidget(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                isVisible:
                                                                    false,
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
                                                              child:
                                                                  ButtonWidget(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                isVisible:
                                                                    false,
                                                                onTap: () {
                                                                  selectedProduct1
                                                                      .add(data
                                                                          .id!);
                                                                  print(
                                                                      selectedProduct1);
                                                                  context
                                                                      .read<
                                                                          StoreCubit>()
                                                                      .deleteProduct(
                                                                        selectedProduct1,
                                                                      )
                                                                      .then(
                                                                          (value) {
                                                                    selectedProduct1
                                                                        .clear();
                                                                    WidgetsBinding
                                                                        .instance
                                                                        .addPostFrameCallback(
                                                                            (timeStamp) async {
                                                                      context
                                                                          .read<
                                                                              StoreCubit>()
                                                                          .getProductDesktop(
                                                                              currentPage,
                                                                              "");
                                                                      Navigator.pop(
                                                                          context);
                                                                    });
                                                                  });
                                                                },
                                                                label:
                                                                    "O'chrish",
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
                                              const Wd(),
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
                                                      dangerCount:
                                                          data.dangerCount,
                                                      totalPrice:
                                                          data.priceWholesale,
                                                      categoryVaule:
                                                          data.categoryId,
                                                      selectedValuee:
                                                          data.priceId,
                                                      // image: data.image,
                                                      id: int.parse(
                                                          data.id.toString()),
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
                                              const Wd(),
                                              InkWell(
                                                onTap: () {
                                                  showCustomDialogWidget(
                                                    context,
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Miqdorni kiriting",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              fontSize: 24),
                                                        ),
                                                        PostInput(
                                                          controller:
                                                              amountController,
                                                        ),
                                                        ButtonWidget(
                                                          width: 200,
                                                          icon: Icons.add,
                                                          label: "Qo'shish",
                                                          color: AppColors
                                                              .primaryColor,
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    StoreCubit>()
                                                                .addProduct(
                                                                    data.id!,
                                                                    double.parse(
                                                                        amountController
                                                                            .text))
                                                                .then((_) {
                                                              context
                                                                  .read<
                                                                      StoreCubit>()
                                                                  .getProduct(
                                                                      currentPage,
                                                                      searchQuery);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                            }).catchError(
                                                                    (error) {
                                                              print(error);
                                                            });
                                                            ;
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    3.5,
                                                    4,
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.plus_one,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Wd(),
                                        InkWell(
                                          onTap: () {
                                            copyToClipboard(data.barcode ?? "Barcode topilmadi !");
                                          },
                                          child: const Icon(
                                            Icons.barcode_reader,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
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
                              numberPages: state.data.total == 0
                                  ? 1
                                  : (state.data.total / state.data.perPage)
                                      .ceil(),
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
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.primaryColor),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DataTableWidget(
                            isHorizantal: true,
                            checkbox: true,
                            dataColumn: const [
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Nomi',
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Kategory',
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Miqdor',
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: 'Kelgan narxi'),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: 'Sotish narxi'),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Shtrix kod',
                                ),
                              ),
                              DataColumn(
                                  label: DataColumnText(
                                txt: 'Pul turi',
                              )),
                              DataColumn(
                                label: DataColumnText(txt: 'OEM'),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: ''),
                              ),
                              // DataColumn(
                              //   label: DataColumnText(txt: ''),
                              // ),    DataColumn(
                              //   label: DataColumnText(txt: ''),
                              // ),
                            ],
                            dataRow:
                                List.generate(state.data.data.length, (index) {
                              var data = state.data.data[index];
                              return DataRow(
                                selected: selectedProduct.contains(data.id),
                                onSelectChanged: (value) {
                                  onSelectedRow(value!, data);
                                },
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 7,
                                      child: DataRowText(
                                        txt: data.name?.toString() ?? 'N/A',
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                        txt: data.category!.name?.toString() ??
                                            'N/A',
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    DataRowText(
                                        txt: moneyFormatterWidthDollor(
                                              double.parse(
                                                data.quantity.toString(),
                                              ),
                                            ) ??
                                            'N/A',
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txtColor:
                                          double.parse(data.dangerCount!) >=
                                                  double.parse(data.quantity!)
                                              ? Colors.red[300]
                                              : null,
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
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    DataRowText(
                                        txt: moneyFormatter(
                                          double.parse(
                                            data.barcode.toString(),
                                          ),
                                        ),
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    DataRowText(
                                        txt: data.price!.name?.toString() ??
                                            'N/A',
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    DataRowText(
                                        txt: data.madeIn?.toString() ?? 'N/A',
                                        txtColor:
                                            double.parse(data.dangerCount!) >=
                                                    double.parse(data.quantity!)
                                                ? Colors.red[300]
                                                : null),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
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
                                                                  selectedProduct1
                                                                      .add(
                                                                          data.id!);
                                                                  print(
                                                                      selectedProduct1);
                                                                  context
                                                                      .read<
                                                                          StoreCubit>()
                                                                      .deleteProduct(
                                                                        selectedProduct1,
                                                                      )
                                                                      .then(
                                                                          (value) {
                                                                    selectedProduct1
                                                                        .clear();
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
                                              const Wd(),
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
                                                          data.id.toString()),
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
                                              const Wd(),
                                              InkWell(
                                                onTap: () {
                                                  showCustomDialogWidget(
                                                    context,
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Miqdorni kiriting",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              fontSize: 24),
                                                        ),
                                                        PostInput(
                                                          controller:
                                                              amountController,
                                                        ),
                                                        ButtonWidget(
                                                          width: 200,
                                                          icon: Icons.add,
                                                          label: "Qo'shish",
                                                          color: AppColors
                                                              .primaryColor,
                                                          onTap: () {
                                                            context
                                                                .read<StoreCubit>()
                                                                .addProduct(
                                                                    data.id!,
                                                                    double.parse(
                                                                        amountController
                                                                            .text))
                                                                .then((_) {
                                                              context
                                                                  .read<
                                                                      StoreCubit>()
                                                                  .getProduct(
                                                                      currentPage,
                                                                      searchQuery);

                                                              Navigator.of(context)
                                                                  .pop(); // Close the dialog
                                                            }).catchError((error) {
                                                              print(error);
                                                            });
                                                            ;
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    3.5,
                                                    4,
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.plus_one,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Wd(),
                                        InkWell(
                                          onTap: () {
                                            copyToClipboard(data.barcode ?? "Barcode topilmadi !");
                                          },
                                          child: const Icon(
                                            Icons.barcode_reader,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
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
                              numberPages: state.data.total == 0
                                  ? 1
                                  : (state.data.total / state.data.perPage)
                                      .ceil(),
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
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
  void copyToClipboard(String textToCopy) {
    Clipboard.setData(ClipboardData(text: textToCopy)).then((value) => SnackBarWidget().showSnackbar("Muvaffaqiyatli", "Barcode nusxa olindi", 4, 6));
  }
}
