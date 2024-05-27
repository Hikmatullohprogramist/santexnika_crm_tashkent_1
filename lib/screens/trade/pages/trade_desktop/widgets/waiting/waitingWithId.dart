import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/waitingWithId/waitin_with_id_cubit.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';

import '../../../../../../tools/appColors.dart';
import '../../../../../../tools/format_date_time.dart';
import '../../../../../../widgets/data_table.dart';
import '../../../../../../widgets/searchble_input.dart';
import '../../../../../../widgets/sized_box.dart';
import '../../../../../../widgets/text_widget/data_culumn_text.dart';
import '../../../../../../widgets/text_widget/data_row_text.dart';
import '../../../../../../widgets/text_widget/text_widget.dart';

class WaitingWIthIdUI extends StatefulWidget {
  final VoidCallback onTap;

  const WaitingWIthIdUI({super.key, required this.onTap});

  @override
  State<WaitingWIthIdUI> createState() => _WaitingWIthIdState();
}

class _WaitingWIthIdState extends State<WaitingWIthIdUI> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 1.4,
          // padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.bottombarColor,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 60,
                color: AppColors.primaryColor,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget(
                          txt: "Vaqtinchalikdan mahsulot chiqarish oynasi")
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 60,
                color: AppColors.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SearchInput(
                        isBool: true,
                        onTap: widget.onTap,
                      ),
                    ],
                  ),
                ),
              ),
              const Hg(
                height: 1,
              ),
              BlocBuilder<WaitingWithIdCubit, WaitingWithIdState>(
                builder: (BuildContext context, state) {
                  if (state is WaitingLoadingWithIdState) {
                    return const CircularProgressIndicator.adaptive();
                  } else if (state is WaitingErrorWithIdState) {
                    return TextWidget(txt: state.message);
                  } else if (state is WaitingSuccessWithIdState) {
                    return Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                width: double.infinity,
                                color: AppColors.primaryColor,
                                child: DataTableWidget(
                                  checkbox: true,
                                  isHorizantal: true,
                                  dataColumn: const [
                                    DataColumn(
                                      label: DataColumnText(txt: "Nomi"),
                                    ),
                                    DataColumn(
                                      label: DataColumnText(txt: "Miqdori"),
                                    ),
                                    DataColumn(
                                      label: DataColumnText(txt: "Kategorya"),
                                    ),
                                    DataColumn(
                                      label: DataColumnText(txt: "Oem"),
                                    ),
                                    DataColumn(
                                      label: DataColumnText(txt: "Shtrih kod"),
                                    ),
                                    DataColumn(
                                      label: DataColumnText(txt: "Bahosi"),
                                    ),
                                    DataColumn(
                                      label:
                                          DataColumnText(txt: "Sotilgan narxi"),
                                    ),
                                    DataColumn(
                                      label: DataColumnText(txt: "Jami narxi"),
                                    ),
                                    DataColumn(
                                      label: DataColumnText(txt: "Vaqt"),
                                    ),
                                  ],
                                  dataRow: List.generate(
                                    state.data.data.baskets.length,
                                    (index) {
                                      var data = state.data;
                                      return DataRow(
                                        onSelectChanged: (v) {},
                                        cells: [
                                          DataCell(
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  7,
                                              child: DataRowText(
                                                txt: data.data.baskets[0].store
                                                        .name ??
                                                    '',
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            DataRowText(
                                              txt: data.data.baskets[0].store
                                                      .quantity ??
                                                  '',
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  8,
                                              child: DataRowText(
                                                txt: data.data.baskets[0].store
                                                        .category.name ??
                                                    '',
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            DataRowText(
                                              txt: data.data.baskets[0].store
                                                      .madeIn ??
                                                  '',
                                            ),
                                          ),
                                          DataCell(
                                            DataRowText(
                                              txt: moneyFormatter(double.parse(
                                                      data.data.baskets[index]
                                                          .store.barcode)) ??
                                                  0,
                                            ),
                                          ),
                                          DataCell(
                                            DataRowText(
                                              txt: moneyFormatterWidthDollor(
                                                    double.parse(
                                                      data.data.baskets[index]
                                                          .store.priceSell,
                                                    ),
                                                  ) ??
                                                  0,
                                            ),
                                          ),
                                          DataCell(
                                            DataRowText(
                                              txt: data
                                                      .data
                                                      .baskets[index]
                                                      .basketPrice[0]
                                                      .agreedPrice ??
                                                  0,
                                            ),
                                          ),
                                          DataCell(
                                            DataRowText(
                                              txt: data.data.baskets[index]
                                                      .basketPrice[0].total ??
                                                  0,
                                            ),
                                          ),
                                          DataCell(
                                            DataRowText(
                                                txt: formatDateWithHours(
                                                    DateTime.parse(
                                                        data.data.createdAt))),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Hg(
                            height: 1,
                          ),
                          Container(
                            width: double.infinity,
                            height: 85,
                            color: AppColors.primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                          txt:
                                              "Jami so'm: ${state.data.total.sum}"),
                                      const Hg(
                                        height: 5,
                                      ),
                                      TextWidget(
                                          txt:
                                              "Jami dollor: ${state.data.total.sum}"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: AppColors.bottombarColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: AppColors.borderColor)),
                                        child: const Icon(
                                          Icons.remove_shopping_cart_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Wd(),
                                      Container(
                                        width: 80,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.bottombarColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColors.borderColor,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add_shopping_cart_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
        ),
      ),
    );
  }
}
