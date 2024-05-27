import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';

import '../../../../../tools/appColors.dart';
import '../../../../../tools/check_price.dart';
import '../../../../../tools/format_date_time.dart';
import '../../../../../tools/money_formatter.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/data_table.dart';
import '../../../../../widgets/my_dialog_widget.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/data_culumn_text.dart';
import '../../../../../widgets/text_widget/data_row_text.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../debt_repayment.dart';
import '../debt_update.dart';

class DesktopOFScrollbarProducts extends StatefulWidget {
  final int id;
  const DesktopOFScrollbarProducts({super.key, required this.id});

  @override
  State<DesktopOFScrollbarProducts> createState() =>
      _DesktopOFScrollbarProductsState();
}

class _DesktopOFScrollbarProductsState
    extends State<DesktopOFScrollbarProducts> {
  int currentPage = 0;

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowCompanyCubit, ShowCompanyState>(
      builder: (BuildContext context, state) {
        if (state is ShowCompanyAttachedProductsLoading) {
          return const CircularProgressIndicator.adaptive();
        } else if (state is ShowCompanyErrorState) {
          return TextWidget(txt: state.error);
        } else if (state is ShowCompanyAttachedProducts) {
          if (state.data.data.isEmpty) {
            return const TextWidget(txt: "Ma'lumot yoq");
          } else {
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
                        dataRow: List.generate(state.data.data.length, (index) {
                          var data = state.data.data[index];
                          return DataRow(
                            onSelectChanged: (value) {},
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 7,
                                  child: DataRowText(
                                    txt: data.name?.toString() ?? 'N/A',
                                    txtColor: double.parse(data.dangerCount!) >=
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
                                    txtColor: double.parse(data.dangerCount!) >=
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
                                    txtColor: double.parse(data.dangerCount!) >=
                                            double.parse(data.quantity!)
                                        ? Colors.red[300]
                                        : null),
                              ),
                              DataCell(
                                DataRowText(
                                  txtColor: double.parse(data.dangerCount!) >=
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
                                    txtColor: double.parse(data.dangerCount!) >=
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
                                    txtColor: double.parse(data.dangerCount!) >=
                                            double.parse(data.quantity!)
                                        ? Colors.red[300]
                                        : null),
                              ),
                              DataCell(
                                DataRowText(
                                    txt: data.price!.name?.toString() ?? 'N/A',
                                    txtColor: double.parse(data.dangerCount!) >=
                                            double.parse(data.quantity!)
                                        ? Colors.red[300]
                                        : null),
                              ),
                              DataCell(
                                DataRowText(
                                    txt: data.madeIn?.toString() ?? 'N/A',
                                    txtColor: double.parse(data.dangerCount!) >=
                                            double.parse(data.quantity!)
                                        ? Colors.red[300]
                                        : null),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showCustomDialogWidget(
                                          context,
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                        Navigator.pop(context);
                                                      },
                                                      label: 'Bekor qilish',
                                                    ),
                                                  ),
                                                  const Wd(),
                                                  Expanded(
                                                    child: ButtonWidget(
                                                      color: AppColors
                                                          .primaryColor,
                                                      isVisible: false,
                                                      // onTap: () {
                                                      //   selectedProduct1
                                                      //       .add(data.id!);
                                                      //   print(
                                                      //       selectedProduct1);
                                                      //   context
                                                      //       .read<
                                                      //       StoreCubit>()
                                                      //       .deleteProduct(
                                                      //     selectedProduct1,
                                                      //   )
                                                      //       .then((value) {
                                                      //     selectedProduct1
                                                      //         .clear();
                                                      //     WidgetsBinding
                                                      //         .instance
                                                      //         .addPostFrameCallback(
                                                      //             (timeStamp) async {
                                                      //           context
                                                      //               .read<
                                                      //               StoreCubit>()
                                                      //               .getProduct(
                                                      //               currentPage,
                                                      //               "");
                                                      //           Navigator.pop(
                                                      //               context);
                                                      //         });
                                                      //   });
                                                      // },
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Miqdorni kiriting",
                                                style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                    fontSize: 24),
                                              ),
                                              PostInput(
                                                controller: controller,
                                              ),
                                              ButtonWidget(
                                                width: 200,
                                                icon: Icons.add,
                                                label: "Qo'shish",
                                                color: AppColors.primaryColor,
                                                onTap: () {
                                                  context
                                                      .read<ShowCompanyCubit>()
                                                      .addProduct(
                                                          data.id!,
                                                          widget.id,
                                                          double.parse(
                                                              controller.text))
                                                      .then((_) {
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

                            context
                                .read<ShowCompanyCubit>()
                                .getAttachedProducts(widget.id,currentPage + 1 );
                          },
                          numberPages: state.data.total == 0
                              ? 1
                              : (state.data.total / state.data.perPage).ceil(),
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
                            buttonSelectedForegroundColor: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
