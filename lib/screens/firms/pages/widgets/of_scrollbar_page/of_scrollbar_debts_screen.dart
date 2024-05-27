
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
import '../../../cubit/company_cubit.dart';
import '../debt_repayment.dart';
import '../debt_update.dart';

class DesktopOFScrollbarDebtsScreen extends StatefulWidget {
  final int id;
  const DesktopOFScrollbarDebtsScreen({super.key, required this.id});

  @override
  State<DesktopOFScrollbarDebtsScreen> createState() => _DesktopOFScrollbarDebtsScreenState();
}

class _DesktopOFScrollbarDebtsScreenState extends State<DesktopOFScrollbarDebtsScreen> {
  @override
  Widget build(BuildContext context) {
    return             BlocBuilder<ShowCompanyCubit, ShowCompanyState>(
      builder: (BuildContext context, state) {
        if (state is ShowCompanyLoadingState) {
          return const CircularProgressIndicator.adaptive();
        } else if (state is ShowCompanyErrorState) {
          return TextWidget(txt: state.error);
        } else if (state is ShowCompanySuccessState) {
          if (state.data.data.isEmpty) {
            return const TextWidget(txt: "Ma'lumot yoq");
          } else {
            return Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: AppColors.primaryColor,
                      child: SingleChildScrollView(
                        child: DataTableWidget(
                          dataColumn: const [
                            DataColumn(
                              label: DataColumnText(txt: 'Qarzi'),
                            ),
                            DataColumn(
                              label: DataColumnText(txt: 'Turi'),
                            ),
                            DataColumn(
                              label: DataColumnText(txt: "Pul turi"),
                            ),
                            DataColumn(
                              label: DataColumnText(txt: 'Vaqti'),
                            ),
                            DataColumn(
                              label: DataColumnText(txt: ''),
                            ),
                            DataColumn(
                              label: DataColumnText(txt: 'Izoh'),
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
                                onSelectChanged: (v) {},
                                cells: [
                                  DataCell(
                                    onTap: () {
                                      showCustomDialogWidget(
                                        context,
                                        DebTrepaymentWidget(
                                          allPrice: double.parse(
                                              data.price.toString()),
                                          id: widget.id,
                                        ),
                                        4,
                                        1.7,
                                      );
                                    },
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context)
                                          .width /
                                          10,
                                      child: DataRowText(
                                        txt: moneyFormatterWidthDollor(
                                          double.parse(
                                            data.price,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    onTap: () {
                                      showCustomDialogWidget(
                                        context,
                                        DebTrepaymentWidget(
                                          allPrice: double.parse(
                                              data.price.toString()),
                                          id: widget.id,
                                        ),
                                        4,
                                        1.7,
                                      );
                                    },
                                    DataRowText(
                                      txt: data.type.name,
                                    ),
                                  ),
                                  DataCell(
                                    onTap: () {
                                      showCustomDialogWidget(
                                        context,
                                        DebTrepaymentWidget(
                                          allPrice: double.parse(
                                              data.price.toString()),
                                          id: widget.id,
                                        ),
                                        4,
                                        1.7,
                                      );
                                    },
                                    DataRowText(
                                      txt: checkPrice(data.priceId),
                                    ),
                                  ),
                                  DataCell(
                                    onTap: () {
                                      showCustomDialogWidget(
                                        context,
                                        DebTrepaymentWidget(
                                          allPrice: double.parse(
                                              data.price.toString()),
                                          id: widget.id,
                                        ),
                                        4,
                                        1.7,
                                      );
                                    },
                                    DataRowText(
                                      txt: formatDateWithSlesh(
                                        DateTime.parse(
                                          data.createdAt.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    onTap: () {
                                      showCustomDialogWidget(
                                        context,
                                        DebTrepaymentWidget(
                                          allPrice: double.parse(
                                              data.price.toString()),
                                          id: widget.id,
                                        ),
                                        4,
                                        1.7,
                                      );
                                    },
                                    DataRowText(
                                      txt: data.typeId != 4
                                          ? "To'langan"
                                          : "Qarzdorlik",
                                    ),
                                  ),
                                  DataCell(
                                    onTap: () {
                                      showCustomDialogWidget(
                                        context,
                                        DebTrepaymentWidget(
                                          allPrice: double.parse(
                                              data.price.toString()),
                                          id: widget.id,
                                        ),
                                        4,
                                        1.7,
                                      );
                                    },
                                    DataRowText(
                                      txt: data.comment ?? "",
                                    ),
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
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  TextWidget(
                                                    txt: "O'chirish",
                                                    txtColor:
                                                    Colors.red,
                                                    size: 24.sp,
                                                  ),
                                                  const TextWidget(
                                                    txt:
                                                    "Rostdan ham o`chirmoqchimisiz?",
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                        ButtonWidget(
                                                          color: AppColors
                                                              .primaryColor,
                                                          isVisible:
                                                          false,
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          label:
                                                          'Bekor qilish',
                                                        ),
                                                      ),
                                                      const Wd(),
                                                      Expanded(
                                                        child:
                                                        ButtonWidget(
                                                          color: AppColors
                                                              .primaryColor,
                                                          isVisible:
                                                          false,
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                ShowCompanyCubit>()
                                                                .deletePayCompany(
                                                                data
                                                                    .id,
                                                                data
                                                                    .companyId)
                                                                .then(
                                                                    (value) {
                                                                  WidgetsBinding
                                                                      .instance
                                                                      .addPostFrameCallback(
                                                                          (timeStamp) async {
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                });
                                                          },
                                                          label:
                                                          "O'chrish",
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
                                              DebUpdateWidget(
                                                allPrice: double.parse(
                                                  data.price.toString(),
                                                ),
                                                id: data.companyId,
                                                selectedValuee:
                                                data.priceId,
                                                selectedTypesValuee:
                                                data.typeId,
                                                debtId: data.id,
                                                comment: data.comment,
                                                forFirms: true,
                                              ),
                                              4,
                                              1.7,
                                            );
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
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
                    ),
                  ),
                  const Hg(
                    height: 3,
                  ),
                  Container(
                    height: 104,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                  txt: "Qarzi (\$): ${moneyFormatter(
                                    double.parse(
                                      state.data.debtsDollar.toString(),
                                    ),
                                  )}"),
                              const Hg(),
                              TextWidget(
                                  txt: "Qarzi (So`m): ${moneyFormatter(
                                    double.parse(
                                      state.data.debtsSum.toString(),
                                    ),
                                  )}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
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
