import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:santexnika_crm/screens/expenses/cubit/expenses_cubit.dart';
import 'package:santexnika_crm/screens/expenses/pages/expenses_mobile/widget/add_and_update.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/error_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/input/mobile_search.dart';
import '../../../../widgets/sized_box.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import '../../../main/mobile/widget/nav_bar.dart';

class ExpensesMobile extends StatefulWidget {
  const ExpensesMobile({super.key});

  @override
  State<ExpensesMobile> createState() => _ExpensesMobileState();
}

class _ExpensesMobileState extends State<ExpensesMobile> {
  late ExpensesCubit expensesCubit;

  @override
  void initState() {
    expensesCubit = context.read<ExpensesCubit>();
    expensesCubit.refreshExpanses();
    expensesCubit.pageRequest();
    expensesCubit.isMobile = true;

    super.initState();
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
            context.read<ExpensesCubit>().searchExpenses(query.trim());
          } else {
            expensesCubit.refreshExpanses();
          }
        },
      );
    }
  }

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      drawer: const NavBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const TextWidget(txt: "Chiqimlar"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          expensesCubit.refreshExpanses();
        },
        child: Column(
          children: [
            const Hg(),
            MobileSearchInput(
              onChanged: (c) {
                handleSearch(c);
              },
            ),
            const Hg(
              height: 2,
            ),
            BlocBuilder<ExpensesCubit, ExpensesState>(
              builder: (BuildContext context, state) {
                if (state is ExpensesLoadingState) {
                  return const Expanded(
                      child: Center(child: ApiLoadingWidget()));
                } else if (state is ExpensesErrorState) {
                  return MobileAPiError(
                    message: state.error,
                    onTap: () {
                      context.read<ExpensesCubit>().getExpenses(0, '');
                    },
                  );
                } else if (state is ExpensesSuccessState) {
                  return Expanded(
                    child: PagedListView(
                      pagingController: expensesCubit.pagingController,
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: (context, item, index) {
                          if (index < state.data.data.length) {
                            var data = state.data.data[index];
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (v) {
                                      showMobileDialogWidget(
                                        context,
                                        MobileExpensesDialog(
                                          isBool: false,
                                          id: data.id,
                                          name: data.user!.name,
                                          comment: data.comment,
                                          typeId: data.typeId,
                                          priceId: data.priceId,
                                          cost: data.cost,
                                        ),
                                        1.2,
                                        1.5,
                                      );
                                    },
                                    icon: Icons.edit,
                                    backgroundColor: AppColors.selectedColor,
                                    foregroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  SlidableAction(
                                    onPressed: (v) {
                                      mobileDeletedDialog(
                                        context,
                                        () {
                                          context
                                              .read<ExpensesCubit>()
                                              .deleteExpense(
                                                data.id!,
                                              );
                                          Get.back();
                                        },
                                      );
                                    },
                                    icon: Icons.delete,
                                    backgroundColor: AppColors.errorColor,
                                    foregroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: MobileBackgroundWidget(
                                  child: Column(
                                    children: [
                                      RowsTextWidget(
                                        title: 'Izoh: ${index}',
                                        name: data.comment,
                                      ),
                                      const Hg(
                                        height: 5,
                                      ),
                                      RowsTextWidget(
                                        title: 'Sana: ',
                                        name: formatDate(
                                          DateTime.parse(
                                            data.createdAt.toString(),
                                          ),
                                        ),
                                      ),
                                      const Hg(
                                        height: 5,
                                      ),
                                      RowsTextWidget(
                                        title: 'Summa: ',
                                        name: moneyFormatterWidthDollor(
                                          double.parse(data.cost ?? '0'),
                                        ),
                                      ),
                                      const Hg(
                                        height: 5,
                                      ),
                                      RowsTextWidget(
                                        title: 'Pul turi: ',
                                        name: data.price?.name ?? '',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  );
                } else if (state is ExpensesSearchSuccessState) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.data.data.length,
                      itemBuilder: (context, index) {
                        if (index < state.data.data.length) {
                          var data = state.data.data[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (v) {
                                    showMobileDialogWidget(
                                      context,
                                      MobileExpensesDialog(
                                        isBool: false,
                                        id: data.id,
                                        name: data.user!.name,
                                        comment: data.comment,
                                        typeId: data.typeId,
                                        priceId: data.priceId,
                                        cost: data.cost,
                                      ),
                                      1.2,
                                      1.5,
                                    );
                                  },
                                  icon: Icons.edit,
                                  backgroundColor: AppColors.selectedColor,
                                  foregroundColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                SlidableAction(
                                  onPressed: (v) {
                                    mobileDeletedDialog(
                                      context,
                                      () {
                                        context
                                            .read<ExpensesCubit>()
                                            .deleteExpense(
                                              data.id!,
                                            );
                                        Get.back();
                                      },
                                    );
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: AppColors.errorColor,
                                  foregroundColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: MobileBackgroundWidget(
                                child: Column(
                                  children: [
                                    RowsTextWidget(
                                      title: 'Izoh: ${index}',
                                      name: data.comment,
                                    ),
                                    const Hg(
                                      height: 5,
                                    ),
                                    RowsTextWidget(
                                      title: 'Sana: ',
                                      name: formatDate(
                                        DateTime.parse(
                                          data.createdAt.toString(),
                                        ),
                                      ),
                                    ),
                                    const Hg(
                                      height: 5,
                                    ),
                                    RowsTextWidget(
                                      title: 'Summa: ',
                                      name: moneyFormatterWidthDollor(
                                        double.parse(data.cost ?? '0'),
                                      ),
                                    ),
                                    const Hg(
                                      height: 5,
                                    ),
                                    RowsTextWidget(
                                      title: 'Pul turi: ',
                                      name: data.price?.name ?? '',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          showMobileDialogWidget(
            context,
            const MobileExpensesDialog(
              isBool: true,
            ),
            1.2,
            1.5,
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
