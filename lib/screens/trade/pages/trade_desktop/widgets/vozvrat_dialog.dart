import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:santexnika_crm/models/orders/selled_products.dart';
import 'package:santexnika_crm/screens/sold/cubit/sold_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_cubit.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_desktop/widgets/transfer2store.dart';
import 'package:santexnika_crm/tools/check_price.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';

import '../../../../../models/basket/productsAddModel.dart';
import '../../../../../models/orders/orderWithIdModel.dart';
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

class VozvratDialogWidget extends StatefulWidget {
  const VozvratDialogWidget({super.key});

  @override
  State<VozvratDialogWidget> createState() => _VozvratDialogWidgetState();
}

class _VozvratDialogWidgetState extends State<VozvratDialogWidget> {
  List<SelledProducts> selectedProduct = [];
  int currentPage = 0;

  onSelectedRow(
    bool selected,
    SelledProducts model,
  ) {
    print(selected);
    setState(() {
      if (selected) {
        selectedProduct.add(model);
      } else {
        selectedProduct.remove(model);
      }

      print(selectedProduct);
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
            context
                .read<SoldCubit>()
                .getSelledProducts(query.trim(), currentPage);
          } else {
            context
                .read<SoldCubit>()
                .getSelledProducts(query.trim(), currentPage);
            searchQuery = "";
          }
        },
      );
    }
  }

  String searchQuery = "";

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
                  txt: 'Sotilgan mahsulotlar',
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
          BlocBuilder<SoldCubit, SoldState>(
            builder: (context, state) {
              if (state is SoldLoadingState) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state is SoldProductsErrorState) {
                return TextWidget(
                  txt: state.error,
                  txtColor: Colors.white,
                );
              } else if (state is SoldProductsSuccessState) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: AppColors.primaryColor,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(

                            width: double.infinity,

                            child: DataTableWidget(
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
                                    txt: 'Haridor',
                                  ),
                                ),
                                const DataColumn(
                                    label: DataColumnText(
                                  txt: 'Miqdor',
                                )),
                                const DataColumn(
                                    label:
                                        DataColumnText(txt: 'Kelishilgan narxi')),
                                const DataColumn(
                                    label: DataColumnText(txt: 'Vaqti')),
                              ],
                              dataRow:
                                  List.generate(state.data.data.length, (index) {
                                var data = state.data.data[index];

                                return DataRow(
                                  onSelectChanged: (selected) {
                                    onSelectedRow(selected!, data);
                                  },
                                  selected: selectedProduct
                                      .any((element) => element == data),
                                  cells: [
                                    DataCell(
                                      DataRowText(
                                        txt:
                                            data.store!.name?.toString() ?? 'N/A',
                                      ),
                                    ),
                                    DataCell(
                                      DataRowText(
                                          txt: data.customer == null
                                              ? "Xaridorsiz savdo"
                                              : data.customer!.name),
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
                                      // Assuming this is inside a widget build method or a similar context
                                      DataRowText(
                                          txt:
                                              "${checkPrice(data.basketPrices[0].priceId)} / ${data.basketPrices[0].agreedPrice}"),
                                    ),
                                    DataCell(
                                      DataRowText(
                                          txt: formatDateWithHours(
                                              data.createdAt)),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            color: AppColors.bottombarColor,
                            child: NumberPaginator(
                              initialPage: currentPage,
                              onPageChange: (page) {
                                currentPage = page;

                                context.read<SoldCubit>().getSelledProducts(
                                      searchQuery,
                                      currentPage + 1,
                                    );
                              },
                              numberPages:
                                  (state.data.total / state.data.perPage)
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
                return Container(
                  width: 121,
                  height: 123,
                  color: Colors.amber,
                );
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
                    label: "Qaytarish ${selectedProduct.length} ta",
                    icon: Icons.refresh,
                    onTap: () {
                      showCustomDialogWidget(
                        context,
                        Transfer2Store(
                          selectedProducts: selectedProduct,
                          funk: () {
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) async {
                              await context
                                  .read<SoldCubit>()
                                  .getSelledProducts(searchQuery, currentPage);

                              print("Ketti funksiya");
                            });
                            selectedProduct.clear();

                            setState(() {});
                          },
                        ),
                        1.5,
                        1.2,
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
