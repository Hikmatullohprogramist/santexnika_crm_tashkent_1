import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:santexnika_crm/screens/settings/cubit/category/category_cubit.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/add_widgets/category_update.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/data_row_text.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../tools/appColors.dart';
import '../../../../tools/format_date_time.dart';
import '../../../../widgets/data_table.dart';
import '../../../../widgets/text_widget/data_culumn_text.dart';

class DesktopCategoriesUi extends StatefulWidget {
  const DesktopCategoriesUi({super.key});

  @override
  State<DesktopCategoriesUi> createState() => _DesktopCategoriesUiState();
}

class _DesktopCategoriesUiState extends State<DesktopCategoriesUi> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<CategoryCubit>().getCategory(0);
      },
    );
    super.initState();
  }

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadingState) {
          return const Center(
              child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
          ));
        } else if (state is CategoryErrorState) {
          return Text(state.error);
        } else if (state is CategorySuccessState) {
          return state.data.data.isNotEmpty
              ? SingleChildScrollView(
                  child: Container(
                    color: AppColors.primaryColor,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          child: DataTableWidget(
                            dataColumn: const [
                              DataColumn(
                                label: DataColumnText(txt: 'Nomi'),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: 'Boshlangan sana'),
                              ),
                              DataColumn(
                                label: DataColumnText(txt: 'Mahsulot soni'),
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
                                  onSelectChanged: (value) {},
                                  cells: [
                                    DataCell(
                                      DataRowText(
                                        txt: data.name ?? "",
                                      ),
                                    ),
                                    DataCell(
                                      DataRowText(
                                        txt: formatDate(
                                          DateTime.parse(data.createdAt ?? ''),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      DataRowText(
                                        txt: data.storesCount.toString() ?? 0,
                                      ),
                                    ),
                                    DataCell(
                                      Row(children: [
                                        IconButton(
                                          onPressed: () {
                                            deletedDialog(context, () {
                                              context
                                                  .read<CategoryCubit>()
                                                  .deleteCategory(data.id ?? 0)
                                                  .then(
                                                    (value) => Get.back(),
                                                  );
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showCustomDialogWidget(
                                              context,
                                              UpdateCategoryWidges(
                                                  name: data.name ?? "",
                                                  branchId:
                                                      data.branch!.id ?? 0,
                                                  categoryId: data.id ?? 0),
                                              3,
                                              2,
                                            );
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ]),
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
                                  .read<CategoryCubit>()
                                  .getCategory(currentPage + 1);
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
                  ),
                )
              : const TextWidget(txt: "Ma'lumotlar yoq");
        } else {
          return Container();
        }
      },
      listener: (context, state) {},
    );
  }
}
