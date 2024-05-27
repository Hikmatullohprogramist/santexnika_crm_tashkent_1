import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/returned_ones/cubit/returned_store_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/data_table.dart';
import 'package:santexnika_crm/widgets/searchble_input.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/data_culumn_text.dart';
import 'package:santexnika_crm/widgets/text_widget/data_row_text.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class ReturnedOnesDesktopUI extends StatefulWidget {
  const ReturnedOnesDesktopUI({super.key});

  @override
  State<ReturnedOnesDesktopUI> createState() => _ReturnedOnesDesktopUIState();
}

class _ReturnedOnesDesktopUIState extends State<ReturnedOnesDesktopUI> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        context.read<ReturnedStoreCubit>().getReturnedDesktopStore(1, '');
      },
    );
    super.initState();
  }

  Timer? searchTime;

  void handleSearch(String query) {
    if (mounted) {
      searchTime?.cancel();

      searchTime = Timer(const Duration(microseconds: 600), () {
        if (query.isNotEmpty) {
          searchQuery = query;
          currentPage=0;
          context.read<ReturnedStoreCubit>().searchReturnedOnes(query.trim());
        } else {
          context.read<ReturnedStoreCubit>().getReturnedStore(0, '');
          searchQuery="";
        }
      });
    }
  }

  int currentPage = 0;
  String searchQuery = "";

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
                children: [TextWidget(txt: "Qaytarilganlar bo'limi")],
              ),
            ),
          ),
          Hg(
            height: 1,
          ),
          Container(
            height: 100,
            width: double.infinity,
            color: AppColors.primaryColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  SearchInput(
                    onChanged: (v) {
                      handleSearch(v);
                    },
                  ),
                ],
              ),
            ),
          ),
          const Hg(
            height: 3,
          ),
          BlocBuilder<ReturnedStoreCubit, ReturnedStoreState>(
            builder: (BuildContext context, state) {
              if (state is ReturnedStoreLoadingState) {
                return CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.whiteColor,
                );
              } else if (state is ReturnedStoreErrorState) {
                return Center(
                  child: TextWidget(
                    txt: state.error,
                  ),
                );
              } else if (state is ReturnedStoreSuccessState) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      color: AppColors.primaryColor,
                      child: DataTableWidget(
                        dataColumn: const [
                          DataColumn(
                            label: DataColumnText(txt: 'Nomi'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Miqdori'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Narxi'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Izoh'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Sotuvchi'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Sana'),
                          ),
                        ],
                        dataRow: List.generate(
                          state.data.data.length,
                          (index) {
                            var data = state.data.data[index];
                            return DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width / 6,
                                    child: DataRowText(
                                      txt: data.store!.name,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  DataRowText(
                                    txt: moneyFormatterWidthDollor(
                                      double.parse(
                                        data.quantity.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  DataRowText(
                                    txt: moneyFormatterWidthDollor(
                                        double.tryParse(data.cost ?? "0.0") ??
                                            0.0),
                                  ),
                                ),
                                DataCell(
                                  DataRowText(txt: data.comment),
                                ),
                                DataCell(
                                  DataRowText(
                                    txt: data.user!.name ?? "",
                                  ),
                                ),
                                DataCell(
                                  DataRowText(
                                    txt: formatDateWithHours(
                                      DateTime.parse(data.createdAt!),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }else if (state is ReturnedStoreSearchSuccessState) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      color: AppColors.primaryColor,
                      child: DataTableWidget(
                        dataColumn: const [
                          DataColumn(
                            label: DataColumnText(txt: 'Nomi'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Miqdori'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Narxi'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Izoh'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Sotuvchi'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Sana'),
                          ),
                        ],
                        dataRow: List.generate(
                          state.data.data.length,
                          (index) {
                            var data = state.data.data[index];
                            return DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width / 6,
                                    child: DataRowText(
                                      txt: data.store!.name,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  DataRowText(
                                    txt: moneyFormatterWidthDollor(
                                      double.parse(
                                        data.quantity.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  DataRowText(
                                    txt: moneyFormatterWidthDollor(
                                        double.tryParse(data.cost ?? "0.0") ??
                                            0.0),
                                  ),
                                ),
                                DataCell(
                                  DataRowText(txt: data.comment),
                                ),
                                DataCell(
                                  DataRowText(
                                    txt: data.user!.name ?? "",
                                  ),
                                ),
                                DataCell(
                                  DataRowText(
                                    txt: formatDateWithHours(
                                      DateTime.parse(data.createdAt!),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
