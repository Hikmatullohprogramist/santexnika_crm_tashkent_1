import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/screens/customer/widgets/pay_off_debt.dart';
import 'package:santexnika_crm/screens/firms/pages/widgets/debt_repayment.dart';
import 'package:santexnika_crm/screens/settings/cubit/users/users_cubit.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/widget/update_payment_widget.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/check_price.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/data_table.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/data_culumn_text.dart';
import 'package:santexnika_crm/widgets/text_widget/data_row_text.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../tools/money_formatter.dart';
import 'add_payment_widget.dart';

class UserExpenses extends StatefulWidget {
  final VoidCallback onTap;
  final String? name;
  final int id;

  const UserExpenses(
      {super.key, required this.onTap, this.name, required this.id});

  @override
  State<UserExpenses> createState() => _UserExpensesState();
}

class _UserExpensesState extends State<UserExpenses> {
  int? id;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      TextWidget(txt: "${widget.name}ning oylik tarixi"),
                      const Wd(),
                      ButtonWidget(
                        width: 200,
                        icon: Icons.add,
                        label: "Oylik qo'shish",
                        onTap: () {
                          showCustomDialogWidget(
                            context,
                            UserPaymentAddWidget(
                              id: widget.id,
                            ),
                            4,
                            1.7,
                          );
                        },
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: widget.onTap,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: TextWidget(txt: '❌'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Hg(
            height: 3,
          ),
          BlocBuilder<UsersCubit, UsersState>(
            builder: (BuildContext context, state) {
              if (state is UserLoadingState) {
                return const CircularProgressIndicator.adaptive();
              } else if (state is UserErrorState) {
                return TextWidget(txt: state.error);
              } else if (state is UserPaymentSuccessState) {
                if (state.data.data.isEmpty) {
                  return const TextWidget(txt: empty);
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
                                    label: DataColumnText(txt: 'ID'),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: 'Izoh'),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: "Summa"),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: 'Vaqti'),
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
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                10,
                                            child: DataRowText(
                                                txt: data.id.toString()),
                                          ),
                                        ),
                                        DataCell(
                                          DataRowText(
                                            txt: data.comment,
                                          ),
                                        ),
                                        DataCell(
                                          DataRowText(
                                            txt: moneyFormatter(
                                                double.parse(data.price)),
                                          ),
                                        ),
                                        DataCell(
                                          DataRowText(
                                            txt: formatDateWithHours(
                                              DateTime.parse(
                                                data.updatedAt.toString(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                showCustomDialogWidget(
                                                  context,
                                                  UserPaymentUpdateWidget(
                                                      userId: data.userId,
                                                      paymentId: data.id,
                                                      paymentPrice: data.price,
                                                      paymentComment:
                                                          data.comment),
                                                  4,
                                                  1.7,
                                                );
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showCustomDialogWidget(
                                                  context,
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
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
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              label:
                                                                  'Bekor qilish',
                                                            ),
                                                          ),
                                                          const Wd(),
                                                          Expanded(
                                                            child: ButtonWidget(
                                                              color: AppColors
                                                                  .primaryColor,
                                                              isVisible: false,
                                                              onTap: () {
                                                                context
                                                                    .read<
                                                                        UsersCubit>()
                                                                    .deleteUserPaymentHistory(
                                                                        data.id,
                                                                        data
                                                                            .userId)
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
                                              icon: Icon(
                                                Icons.delete,
                                                color: AppColors.errorColor,
                                              ),
                                            ),
                                          ],
                                        )),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                        txt: "Jami summa: ${moneyFormatter(
                                      double.parse(
                                        state.data.all_sum.toString(),
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
          ),
        ],
      ),
    );
  }
}
