import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/screens/firms/pages/firms_desktop/pages/debts_of_firm_desktop.dart';
import 'package:santexnika_crm/screens/firms/pages/widgets/dialog_widgets.dart';
import 'package:santexnika_crm/screens/firms/pages/widgets/firm_update.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/data_table.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/searchble_input.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/data_culumn_text.dart';
import 'package:santexnika_crm/widgets/text_widget/data_row_text.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class FirmsDesktopUI extends StatefulWidget {
  const FirmsDesktopUI({super.key});

  @override
  State<FirmsDesktopUI> createState() => _FirmsDesktopUIState();
}

class _FirmsDesktopUIState extends State<FirmsDesktopUI> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        context.read<CompanyCubit>().getCompany(0);
      },
    );
    super.initState();
  }

  int currentPage = 0;
  PageController pageController = PageController();

  Timer? searchTime;

  void handleSearch(String query) {
    if (mounted) {
      searchTime?.cancel();

      searchTime = Timer(
        const Duration(milliseconds: 600),
        () {
          if (query.isNotEmpty) {
            searchQuery = query;

            currentPage = 0;
            context
                .read<CompanyCubit>()
                .getCompany(currentPage, 10, searchQuery);
          } else {
            context.read<CompanyCubit>().getCompany(1);
            searchQuery = "";
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
      body: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWidget(txt: "Firmalar bo'limi"),
                  IconButton(
                    onPressed: () {
                      WidgetsBinding.instance
                          .addPostFrameCallback((timeStamp) async {
                        await context.read<CompanyCubit>().getCompany(0);
                      });
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: AppColors.whiteColor,
                    ),
                  )
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
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SearchInput(
                    onChanged: (e) {
                      handleSearch(e);
                    },
                  ),
                  ButtonWidget(
                    width: 200.w,
                    icon: Icons.add,
                    label: "Qo'shish",
                    fontSize: 14.sp,
                    onTap: () {
                      showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          final curvedValue =
                              Curves.easeInOutBack.transform(a1.value) - 1.0;
                          return Transform(
                            transform: Matrix4.translationValues(
                              0.0,
                              curvedValue * 200,
                              0.0,
                            ),
                            child: Opacity(
                              opacity: a1.value,
                              child: const CompanyDialogWidgets(),
                            ),
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {
                          return Container();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const Hg(
            height: 3,
          ),
          Flexible(
            child: BlocBuilder<CompanyCubit, CompanyState>(
              builder: (context, state) {
                if (state is CompanyLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    ),
                  );
                } else if (state is CompanyErrorState) {
                  return Text(state.error);
                } else if (state is CompanyEmptyState) {
                  return const Expanded(
                    child: TextWidget(
                      txt: empty,
                    ),
                  );
                } else if (state is CompanySuccessState) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: AppColors.primaryColor,
                          width: double.infinity,
                          child: DataTableWidget(
                            dataColumn: const [
                              DataColumn(
                                label: DataColumnText(txt: 'Nomi'),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: "Telefon nomer"),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: 'Sana'),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: ''),
                              ),
                            ],
                            dataRow: List.generate(
                              state.data.data.length,
                              (index) {
                                var data = state.data.data[index];

                                return DataRow(
                                  onSelectChanged: (value) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                      (timeStamp) {
                                        context
                                            .read<ShowCompanyCubit>()
                                            .showCompany(
                                              data.id!,
                                            );
                                      },
                                    );
                                    showGeneralDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierLabel:
                                          MaterialLocalizations.of(context)
                                              .modalBarrierDismissLabel,
                                      barrierColor: Colors.black45,
                                      transitionDuration:
                                          const Duration(milliseconds: 200),
                                      transitionBuilder:
                                          (context, a1, a2, widget) {
                                        final curvedValue = Curves.easeInOutBack
                                                .transform(a1.value) -
                                            1.0;
                                        return Transform(
                                          transform: Matrix4.translationValues(
                                            0.0,
                                            curvedValue * 200,
                                            0.0,
                                          ),
                                          child: Center(
                                            child: Material(
                                              color: AppColors.bottombarColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.5,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.bottombarColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: DebtsOfTheFirm(
                                                  name: data.name,
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  id: data.id ?? 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      pageBuilder: (BuildContext buildContext,
                                          Animation animation,
                                          Animation secondaryAnimation) {
                                        return Container();
                                      },
                                    );
                                  },
                                  cells: [
                                    DataCell(
                                      DataRowText(txt: data.name ?? ""),
                                    ),
                                    DataCell(
                                      DataRowText(txt: data.phone),
                                    ),
                                    DataCell(
                                      DataRowText(
                                        txt: formatDate(
                                          DateTime.parse(data.createdAt ?? ''),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
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
                                                      .read<CompanyCubit>()
                                                      .deleteCompany(data.id!)
                                                      .then(
                                                        (value) => Get.back(),
                                                      );
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              showCustomDialogWidget(
                                                context,
                                                CompanyUpdateDialogWidgets(
                                                  txtName: data.name ?? "",
                                                  txtPhone: data.phone ?? "",
                                                  id: data.id!,
                                                  branchId: data.branchId!,
                                                ),
                                                3,
                                                2,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
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
                                  .read<CompanyCubit>()
                                  .getCompany(currentPage + 1);
                            },
                            numberPages:
                                (state.data.total / state.data.perPage).ceil(),
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
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
