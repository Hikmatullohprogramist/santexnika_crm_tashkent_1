import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/models/customer/customerWithId.dart';
import 'package:santexnika_crm/screens/customer/widgets/pay_off_debt.dart';
import 'package:santexnika_crm/tools/check_price.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';

import '../../../errors/service_error.dart';
import '../../../tools/appColors.dart';
import '../../../tools/format_date_time.dart';
import '../../../tools/money_formatter.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/data_table.dart';
import '../../../widgets/sized_box.dart';
import '../../../widgets/text_widget/data_culumn_text.dart';
import '../../../widgets/text_widget/data_row_text.dart';
import '../../../widgets/text_widget/text_widget.dart';
import '../../firms/pages/widgets/debt_update.dart';
import '../cubit/customer_cubit.dart';
import 'hisobot_tarixi.dart';

class DebtsOfTheCustomers extends StatefulWidget {
  final VoidCallback onTap;
  final String? name;
  final int? id;

  const DebtsOfTheCustomers(
      {super.key, required this.onTap, this.name, this.id});

  @override
  State<DebtsOfTheCustomers> createState() => _DebtsOfTheCustomersState();
}

class _DebtsOfTheCustomersState extends State<DebtsOfTheCustomers> {
  List<CustomerWithId> selectedProduct = [];

  //
  // onSelectedRow(
  //   bool selected,
  //   CustomerWithId model,
  // ) {
  //   setState(() {
  //     if (selected) {
  //       selectedProduct.add(model);
  //     } else {
  //       selectedProduct.remove(model);
  //     }
  //   });
  // }

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
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextWidget(txt: "${widget.name}ning qarz tarixi"),
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
          BlocBuilder<CustomerWithIdCubit, CustomerWithIdState>(
            builder: (BuildContext context, state) {
              if (state is CustomerLoadingWithIdState) {
                return CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.whiteColor,
                );
              } else if (state is CustomerErrorWithIdState) {
                return TextWidget(txt: state.error);
              } else if (state is CustomerSuccessWithIdState) {
                if (state.data.isNotEmpty) {
                  return Expanded(
                    child: Column(
                      children: [
                        state.data[0].data?.isEmpty ?? true
                            ? const Expanded(child: TextWidget(txt: empty))
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: double.infinity,
                                    color: AppColors.primaryColor,
                                    child: DataTableWidget(
                                      dataColumn: const <DataColumn>[
                                        DataColumn(
                                          label: DataColumnText(txt: 'Qarzi'),
                                        ),
                                        DataColumn(
                                          label: DataColumnText(
                                              txt: 'Olgan Vaqti'),
                                        ),
                                        DataColumn(
                                          label: DataColumnText(txt: "Turi"),
                                        ),
                                        DataColumn(
                                          label:
                                              DataColumnText(txt: 'Pul turi'),
                                        ),
                                        DataColumn(
                                          label: DataColumnText(txt: 'Izoh'),
                                        ),
                                        DataColumn(
                                          label: DataColumnText(txt: ''),
                                        ),
                                        DataColumn(
                                          label: DataColumnText(txt: ''),
                                        ),
                                      ],
                                      dataRow: List.generate(
                                        state.data[0].data?.length ?? 0,
                                        (index) {
                                          var data = state.data[0].data![index];
                                          return DataRow(
                                            onSelectChanged: (v) {
                                              showCustomDialogWidget(
                                                context,
                                                PayOffDebtDesktopUI(
                                                  price: data.price,
                                                  id: widget.id,
                                                ),
                                                4,
                                                2,
                                              );
                                            },
                                            cells: [
                                              DataCell(
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width /
                                                          10,
                                                  child: DataRowText(
                                                    txt:
                                                        moneyFormatterWidthDollor(
                                                      double.parse(
                                                        data.price ?? '',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                DataRowText(
                                                  txt: formatDateWithSlesh(
                                                    DateTime.parse(
                                                      data.createdAt ?? '',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                DataRowText(
                                                  txt: data.type!.name ?? '',
                                                ),
                                              ),
                                              DataCell(
                                                DataRowText(
                                                  txt: checkPrice(
                                                    data.priceId!,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                DataRowText(
                                                    txt: data.comment
                                                        .toString()),
                                              ),
                                              DataCell(
                                                DataRowText(
                                                  txt: data.typeId != 4
                                                      ? "To'langan"
                                                      : "Qarzdorlik",
                                                ),
                                              ),
                                              DataCell(
                                                Row(
                                                  children: [
                                        IconButton(
                                                      onPressed: () {
                                                        showCustomDialogWidget(
                                                          context,
                                                          DebUpdateWidget(
                                                            allPrice:
                                                                double.parse(
                                                              data.price
                                                                  .toString(),
                                                            ),
                                                            id: data
                                                                .customerId!,
                                                            selectedValuee:
                                                                data.priceId,
                                                            selectedTypesValuee:
                                                                data.typeId,
                                                            debtId: data.id!,
                                                            comment:
                                                                data.comment,
                                                            forFirms: false,
                                                          ),
                                                          4,
                                                          1.7,
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      ),
                                                    )  ,
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
                                                                .read<
                                                                    CustomerWithIdCubit>()
                                                                .deletePayCustomer(
                                                                    data.id!,
                                                                    data.customerId!)
                                                                .then(
                                                              (value) {
                                                                WidgetsBinding
                                                                    .instance
                                                                    .addPostFrameCallback(
                                                                  (timeStamp) async {
                                                                    context
                                                                        .read<
                                                                            CustomerWithIdCubit>()
                                                                        .getCustomerWithId(
                                                                          data.customerId!,
                                                                        )
                                                                        .then(
                                                                            (_) {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(); // Close the dialog
                                                                    }).catchError(
                                                                            (error) {
                                                                      print(
                                                                          error);
                                                                    });
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.receipt_long,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
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
                                                              child: DesktopHisobotTarixiDialog(), // Use the separate dialog widget here
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
                          height: 110,
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
                                        txt:
                                            "Qarzi so'mda: ${moneyFormatter(double.parse(state.data[0].debts?.allSum.toString() ?? '0'))}"),
                                    const Hg(),
                                    TextWidget(
                                        txt:
                                            "Qarzi dollorda: ${moneyFormatterWidthDollor(double.parse(state.data[0].debts?.allDollar.toString() ?? '0'))}"),
                                  ],
                                ),
                                ButtonWidget(
                                  width: 200,
                                  icon: Icons.add,
                                  label: "Qarz qo'shish",
                                  onTap: () {
                                    showCustomDialogWidget(
                                      context,
                                      AddDebtDesktopUI(
                                        forCustomer: true,
                                        id: widget.id,
                                      ),
                                      3,
                                      2,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return const TextWidget(txt: empty);
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
