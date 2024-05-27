import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:santexnika_crm/screens/sold/cubit/sold_cubit.dart';
import 'package:santexnika_crm/screens/sold/widget/sold_lists.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';

import '../../../../widgets/data_table.dart';
import '../../../../widgets/searchble_input.dart';
import '../../../../widgets/text_widget/data_culumn_text.dart';
import '../../../../widgets/text_widget/data_row_text.dart';
import '../../../../widgets/text_widget/text_widget.dart';

class SoldDesktop extends StatefulWidget {
  const SoldDesktop({super.key});

  @override
  State<SoldDesktop> createState() => _SoldDesktopState();
}

class _SoldDesktopState extends State<SoldDesktop> {
  int? id;

  PageController pageController = PageController();

  void _switchPage(int index) {
    pageController.jumpToPage(index);
  }

  late SoldCubit soldCubit;

  @override
  void initState() {
    soldCubit = context.read<SoldCubit>();
    soldCubit.isMobile = false;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<SoldCubit>().getSoldDesktop(1, '');
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
          currentPage = 0;
          context.read<SoldCubit>().searchSold(searchQuery);
        } else {
          context.read<SoldCubit>().getSold(0, '');
          searchQuery = "";
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
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          Column(
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
                      TextWidget(txt: "Sotilgan maxsulotlar ro'yxati")
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
                      SearchInput(
                        onChanged: (v) {
                          handleSearch(v);
                        },
                      ),
                      IconButton(
                          onPressed: () async {
                            await context.read<SoldCubit>().getSold(0, '');
                          },
                          icon: Icon(Icons.refresh_outlined))
                    ],
                  ),
                ),
              ),
              const Hg(),
              BlocBuilder<SoldCubit, SoldState>(
                builder: (context, state) {
                  if (state is SoldLoadingState) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: AppColors.whiteColor,
                        ),
                      ),
                    );
                  } else if (state is SoldErrorState) {
                    return TextWidget(txt: state.error);
                  } else if (state is SoldSuccessState) {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: AppColors.primaryColor,
                              width: double.infinity,
                              child: DataTableWidget(
                                // isHorizantal: true,
                                checkbox: false,
                                dataColumn: const [
                                  DataColumn(
                                    label: DataColumnText(txt: 'Chek raqami'),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: "Xaridor"),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: "Sotuvchi"),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: "Sana"),
                                  ),
                                ],
                                dataRow: List.generate(
                                  state.data.data.length,
                                  (index) {
                                    var data = state.data.data[index];
                                    return DataRow(
                                      onSelectChanged: (value) async {
                                        await context
                                            .read<SoldCubit>()
                                            .getSoldWithId(1, data.id!);

                                        _switchPage(1);
                                      },
                                      cells: [
                                        DataCell(
                                          DataRowText(
                                            txt: data.id.toString() ?? 0,
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                7,
                                            child: DataRowText(
                                              txt: data.customer?.name ??
                                                  'Xaridorsiz savdo',
                                            ),
                                            // width: MediaQuery.sizeOf(context).width/10,
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                11,

                                            child: DataRowText(
                                                txt: data.user?.name ?? ''),
                                            // width: MediaQuery.sizeOf(context).width/10,
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            child: DataRowText(
                                              txt: formatDateWithHours(
                                                DateTime.parse(
                                                  data.createdAt.toString(),
                                                ),
                                              ),
                                            ),
                                            // width: MediaQuery.sizeOf(context).width/10,
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
                                      .read<SoldCubit>()
                                      .getSold(currentPage + 1, searchQuery);
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
                    );
                  } else if (state is SoldSearchSuccessState) {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: AppColors.primaryColor,
                              width: double.infinity,
                              child: DataTableWidget(
                                // isHorizantal: true,
                                checkbox: false,
                                dataColumn: const [
                                  DataColumn(
                                    label: DataColumnText(txt: 'Chek raqami'),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: "Xaridor"),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: "Sotuvchi"),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: "Sana"),
                                  ),
                                ],
                                dataRow: List.generate(
                                  state.data.data.length,
                                  (index) {
                                    var data = state.data.data[index];
                                    return DataRow(
                                      onSelectChanged: (value) async {
                                        await context
                                            .read<SoldCubit>()
                                            .getSoldWithId(0, data.id!);

                                        _switchPage(1);
                                      },
                                      cells: [
                                        DataCell(
                                          DataRowText(
                                            txt: data.id.toString() ?? 0,
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                7,
                                            child: DataRowText(
                                              txt: data.customer?.name ??
                                                  'Xaridorsiz savdo',
                                            ),
                                            // width: MediaQuery.sizeOf(context).width/10,
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                11,

                                            child: DataRowText(
                                                txt: data.user?.name ?? ''),
                                            // width: MediaQuery.sizeOf(context).width/10,
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            child: DataRowText(
                                              txt: formatDateWithHours(
                                                DateTime.parse(
                                                  data.createdAt.toString(),
                                                ),
                                              ),
                                            ),
                                            // width: MediaQuery.sizeOf(context).width/10,
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
                                      .read<SoldCubit>()
                                      .getSold(currentPage + 1, searchQuery);
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
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
          ListsSoldScreen(
            onTap: () async {
              await context.read<SoldCubit>().getSoldDesktop(1, '');

              _switchPage(0);
            },
          )
        ],
      ),
    );
  }
}
