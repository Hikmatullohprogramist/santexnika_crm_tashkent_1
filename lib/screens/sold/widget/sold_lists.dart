import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/models/orders/orderWithIdModel.dart';
import 'package:santexnika_crm/screens/sold/cubit/sold_cubit.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_desktop/widgets/transfer2store.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/check_price.dart';
import 'package:santexnika_crm/tools/check_trade_type.dart';
import 'package:santexnika_crm/widgets/bar_text_widget.dart';
import 'package:santexnika_crm/widgets/data_table.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../tools/money_formatter.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/my_dialog_widget.dart';
import '../../../widgets/searchble_input.dart';
import '../../../widgets/sized_box.dart';
import '../../../widgets/text_widget/data_culumn_text.dart';
import '../../../widgets/text_widget/data_row_text.dart';

class ListsSoldScreen extends StatefulWidget {
  final VoidCallback onTap;

  const ListsSoldScreen({
    super.key,
    required this.onTap,
  });

  @override
  State<ListsSoldScreen> createState() => _ListsSoldScreenState();
}

class _ListsSoldScreenState extends State<ListsSoldScreen> {
  int currentPage = 0;
  List<Basket> selectedProduct = [];

  onSelectedRow(
    bool selected,
    Basket model,
  ) {
    setState(() {
      if (selected) {
        selectedProduct.add(model);
      } else {
        selectedProduct.remove(model);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Column(
        children: [
          BlocBuilder<SoldCubit, SoldState>(
            builder: (context, state) {
              if (state is SoldLoadingState) {
                return const ApiLoadingWidget();
              } else if (state is SoldWithIDSuccess) {
                return Container(
                  height: 150,
                  width: double.infinity,
                  color: AppColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SearchInput(
                                  isBool: true,
                                  onTap: widget.onTap,
                                ),
                                const Wd(),
                                TextWidget(
                                  txt: "#${state.data.data!.id.toString()}",
                                  size: 14.sp,
                                ),
                              ],
                            ),
                            const Hg(
                              height: 10,
                            ),
                            Row(
                              children: [
                                BarTextWidgets(
                                  name: "Jami summa so'm",
                                  price: double.parse(
                                    state.data.total!.sum == null
                                        ? "0"
                                        : state.data.total!.sum.toString(),
                                  ),
                                ),
                                const Wd(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      txt: "Jami summa \$:",
                                      size: 14.sp,
                                    ),
                                    TextWidget(
                                      txt: (state.data.total!.dollar ?? 0)
                                          .toString(),
                                      size: 14.sp,
                                    ),
                                  ],
                                ),
                                const Wd(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      txt: "Savdodan tushilgan:",
                                      size: 14.sp,
                                    ),
                                    TextWidget(
                                      txt: (state.data.total!.reduce_price ?? 0)
                                          .toString(),
                                      size: 14.sp,
                                    ),
                                  ],
                                ),
                                const Wd(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      txt: "Savdodan tushilgan turi",
                                      size: 14.sp,
                                    ),
                                    TextWidget(
                                      txt: checkTradeType(
                                        state.data.total!.reduced_price_type,
                                      ),
                                      size: 14.sp,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            ButtonWidget(
                              width: 250,
                              color: AppColors.toqPrimaryColor,
                              label: "Qaytib olish",
                              icon: Icons.refresh,
                              onTap: () {
                                showCustomDialogWidget(
                                  context,
                                  Transfer2Store(
                                    selectedProducts: selectedProduct,
                                  ),
                                  1.5,
                                  1.2,
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }

              return Container();
            },
          ),
          const Hg(),
          BlocBuilder<SoldCubit, SoldState>(
            builder: (context, state) {
              if (state is SoldLoadingState) {
                return CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.whiteColor,
                );
              } else if (state is SoldErrorState) {
                return TextWidget(txt: state.error);
              } else if (state is SoldWithIDSuccess) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: AppColors.primaryColor,
                          width: double.infinity,
                          child: DataTableWidget(
                            checkbox: true,
                            dataColumn: const [
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Nomi',
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Miqdor',
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: 'Kelishilgan narxi'),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: 'Jami narxi'),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: 'Pul turi'),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Shtrix kod',
                                ),
                              ),
                            ],
                            dataRow: List.generate(
                                state.data.data!.baskets!.length, (index) {
                              var data = state.data.data!.baskets![index];
                              return DataRow(
                                selected: selectedProduct
                                    .any((element) => element == data),
                                onSelectChanged: (value) {
                                  onSelectedRow(value!, data);
                                },
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 7,
                                      child: DataRowText(
                                        txt: data.store.name,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatterWidthDollor(
                                        double.parse(
                                          data.quantity,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatterWidthDollor(
                                        double.parse(
                                            data.basketPrice[0].agreedPrice),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                      child: DataRowText(
                                        txt: data.basketPrice[0].priceId == 1
                                            ? moneyFormatter(
                                                double.parse(
                                                  data.basketPrice[0].priceSell,
                                                ),
                                              )
                                            : moneyFormatterWidthDollor(
                                                double.parse(
                                                  data.basketPrice[0].priceSell,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt:
                                          "${checkPrice(data.basketPrice[0].priceId)}",
                                    ),
                                  ),
                                  DataCell(
                                    DataRowText(
                                      txt: moneyFormatter(
                                        double.parse(
                                            data.store.barcode.toString()),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        )
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
    );
  }
}
