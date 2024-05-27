import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:santexnika_crm/screens/expenses/cubit/expenses_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/data_table.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/searchble_input.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../tools/format_date_time.dart';
import '../../../../widgets/text_widget/data_culumn_text.dart';
import '../../../../widgets/text_widget/data_row_text.dart';
import '../../widgets/add_expenses_dialog.dart';

class ExpensesDesktop extends StatefulWidget {
  const ExpensesDesktop({super.key});

  @override
  State<ExpensesDesktop> createState() => _ExpensesDesktopState();
}

class _ExpensesDesktopState extends State<ExpensesDesktop> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<ExpensesCubit>().getExpenses(0, '');
    });
    super.initState();
  }

  int currentPage = 0;
  Timer? searchTime;

  void handelSearch(String query) {
    if (mounted) {
      searchTime?.cancel();
      searchTime = Timer(const Duration(microseconds: 600), () {
        if (query.isNotEmpty) {
          searchQuery = query;
          context.read<ExpensesCubit>().searchExpenses(query.trim());
        } else {
          context.read<ExpensesCubit>().getExpenses(0, '');
        }
      });
    }
  }

  String searchQuery = '';

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
                children: [
                  TextWidget(txt: "Chiqimlar ")
                ],
              ),
            ),
          ),
          const Hg(
            height: 1,
          ),
          Container(
            height: 100,
            width: double.infinity,
            color: AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 1,
                      child: SearchInput(
                        onChanged: (v) {
                          handelSearch(v);
                        },
                      )),
                  Row(
                    children: [
                      ButtonWidget(
                        width: 250,
                        color: AppColors.toqPrimaryColor,
                        label: "Qo'shish",
                        icon: Icons.add,
                        onTap: () {
                          showCustomDialogWidget(
                            context,
                            const AddExpensesDialog(
                              isBool: true,
                            ),
                            4,
                            1.6,
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Hg(
            height: 3,
          ),
          BlocBuilder<ExpensesCubit, ExpensesState>(
            builder: (context, state) {
              if (state is ExpensesLoadingState) {
                return CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.whiteColor,
                );
              } else if (state is ExpensesErrorState) {
                return TextWidget(txt: state.error);
              } else if (state is ExpensesSuccessState) {
                if (state.data.data.isEmpty) {
                  return const TextWidget(txt: "Ma'lumotlar yoq");
                } else {
                  return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: AppColors.primaryColor,
                              width: double.infinity,
                              child: DataTableWidget(
                                dataColumn:   [
                                  const DataColumn(
                                    label: DataColumnText(txt: 'Izoh'),
                                  ),
                                  const DataColumn(
                                    label: DataColumnText(txt: "Sana"),
                                  ),
                                  const DataColumn(
                                    label: DataColumnText(txt: 'Summa'),
                                  ),
                                  const DataColumn(
                                    label: DataColumnText(txt: 'Pul turi'),
                                  ),
                                  const DataColumn(
                                    label: DataColumnText(txt: ''),
                                  )
                                ],
                                dataRow: List.generate(
                                  state.data.data.length,
                                      (index) {
                                    var data = state.data.data[index];
                                    return DataRow(
                                      onSelectChanged: (value) {},
                                      cells: [
                                        DataCell(
                                          SizedBox(
                                            width:
                                            MediaQuery
                                                .sizeOf(context)
                                                .width /
                                                4,
                                        child: DataRowText(
                                          txt: data.comment,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      DataRowText(
                                        txt: formatDate(
                                          DateTime.parse(
                                            data.createdAt.toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      DataRowText(
                                        txt: moneyFormatter(
                                          double.parse(data.cost.toString()),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      DataRowText(
                                        txt: data.price!.name,
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              showCustomDialogWidget(
                                                context,
                                                AddExpensesDialog(
                                                  name: data.user!.name,
                                                  comment: data.comment,
                                                  typeId: data.typeId,
                                                  priceId: data.priceId,
                                                  cost: data.cost,
                                                  id: data.id,
                                                  isBool: false,
                                                ),
                                                4,
                                                1.6,
                                              );
                                            },
                                          ),
                                          const Wd(
                                            width: 30,
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              deletedDialog(
                                                context,
                                                () {
                                                  context
                                                      .read<ExpensesCubit>()
                                                      .deleteExpense(
                                                        data.id!,
                                                      )
                                                      .then((_) {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  }).catchError((error) {
                                                    print(error);
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          color: AppColors.bottombarColor,
                          child: NumberPaginator(
                            initialPage: currentPage,
                            onPageChange: (page) {
                              currentPage = page;

                              context
                                  .read<ExpensesCubit>()
                                  .getExpenses(currentPage + 1, '');
                            },
                            numberPages: (state.data.total / state.data.perPage).ceil(),
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
                  ));
                }
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
