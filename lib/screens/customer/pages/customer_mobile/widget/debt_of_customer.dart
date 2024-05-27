import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/customer/cubit/customer_cubit.dart';
import 'package:santexnika_crm/screens/customer/pages/customer_mobile/widget/add_debt.dart';
import 'package:santexnika_crm/screens/customer/pages/customer_mobile/widget/pay_of_debt.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/error_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile/one_button.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';

import '../../../../../errors/service_error.dart';
import '../../../../../tools/appColors.dart';
import '../../../../../tools/check_price.dart';
import '../../../../../tools/format_date_time.dart';
import '../../../../../widgets/background_widget.dart';
import '../../../../../widgets/text_widget/rows_text_widget.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import 'mobile_update _debt.dart';

class MobileDebtOfCustomer extends StatefulWidget {
  final String? name;
  final int id;

  const MobileDebtOfCustomer({super.key, this.name, required this.id});

  @override
  State<MobileDebtOfCustomer> createState() => _MobileDebtOfCustomerState();
}

class _MobileDebtOfCustomerState extends State<MobileDebtOfCustomer> {
  int? selectedValuee;
  int? typesId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: TextWidget(txt: "${widget.name}ning qarz tarixi"),
        iconTheme: IconThemeData(color: AppColors.whiteColor),
      ),
      backgroundColor: AppColors.bottombarColor,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            BlocBuilder<CustomerWithIdCubit, CustomerWithIdState>(
              builder: (BuildContext context, state) {
                if (state is CustomerLoadingWithIdState) {
                  return const Expanded(child: ApiLoadingWidget());
                } else if (state is CustomerErrorWithIdState) {
                  return MobileAPiError(
                    message: state.error,
                    onTap: () {
                      context
                          .read<CustomerWithIdCubit>()
                          .getCustomerWithId(widget.id!);
                    },
                  );
                } else if (state is CustomerSuccessWithIdState) {
                  if (state.data.isNotEmpty) {
                    return state.data[0].data?.isNotEmpty ?? true
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: state.data.isNotEmpty &&
                                      state.data[0].data != null
                                  ? state.data[0].data!.length
                                  : 0,
                              itemBuilder: (context, index) {
                                var data = state.data[0].data![index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (v) {
                                            showMobileDialogWidget(
                                              context,
                                              MobileDebtUpdate(
                                                forCustomer: true,
                                                id: widget.id,
                                                debtId: data.id!,
                                                selectedValuee: data.priceId,
                                                comment: data.comment,
                                                selectedTypesValuee:
                                                    data.typeId,
                                                price: data.price,
                                              ),
                                              1.2,
                                              2,
                                            );
                                          },
                                          backgroundColor:
                                              AppColors.selectedColor,
                                          icon: Icons.edit,
                                          foregroundColor: AppColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        SlidableAction(
                                          onPressed: (v) {
                                            mobileDeletedDialog(
                                              context,
                                              () {
                                                context
                                                    .read<CustomerWithIdCubit>()
                                                    .deletePayCustomer(
                                                      data.id!,
                                                      data.customerId!,
                                                    );
                                                context
                                                    .read<CustomerWithIdCubit>()
                                                    .getCustomerWithId(
                                                      data.customerId!,
                                                    );
                                                Get.back();
                                              },
                                            );
                                          },
                                          backgroundColor: AppColors.errorColor,
                                          icon: Icons.delete,
                                          foregroundColor: AppColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ],
                                    ),
                                    child: MobileBackgroundWidget(
                                      onTap: () {
                                        showMobileDialogWidget(
                                          context,
                                          MobilePayOfDebt(
                                            forCustomer: true,
                                            id: widget.id,
                                          ),
                                          1.2,
                                          2,
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          RowsTextWidget(
                                            title: "Qarzi: ",
                                            name: moneyFormatterWidthDollor(
                                              double.parse(
                                                  data.price.toString() ?? '0'),
                                            ),
                                          ),
                                          const Hg(),
                                          RowsTextWidget(
                                            title: "Olgan vaqti: ",
                                            name: formatDateWithSlesh(
                                              DateTime.parse(
                                                data.createdAt ?? '20070907',
                                              ),
                                            ),
                                          ),
                                          const Hg(),
                                          RowsTextWidget(
                                            title: "Turi: ",
                                            name: data.type?.name ?? '',
                                          ),
                                          const Hg(),
                                          RowsTextWidget(
                                            title: "Pul turi: ",
                                            name: '${checkPrice(
                                              data.priceId ?? 0,
                                            )}',
                                          ),
                                          const Hg(),
                                          RowsTextWidget(
                                              title: "",
                                              name: data.typeId != 4
                                                  ? "To'langan"
                                                  : "Qarzdorlik"),
                                          const Hg(),
                                          RowsTextWidget(
                                            title: "Izoh: ",
                                            name: "${data.comment}",
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const Expanded(
                            child: Center(
                              child: TextWidget(
                                txt: empty,
                              ),
                            ),
                          );
                  } else {
                    return const Expanded(
                      child: Center(
                        child: TextWidget(txt: empty,),
                      ),
                    );
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
            BlocBuilder<CustomerWithIdCubit, CustomerWithIdState>(
              builder: (BuildContext context, state) {
                if (state is CustomerLoadingWithIdState) {
                  return const SizedBox();
                } else if (state is CustomerErrorWithIdState) {
                  return SizedBox();
                } else if (state is CustomerSuccessWithIdState) {
                  if (state.data.isNotEmpty) {
                    return state.data[0].data?.isNotEmpty ?? true
                        ? Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextWidget(
                                      txt:
                                          "Qarzi so'mda: ${moneyFormatter(double.parse(state.data[0].debts?.allSum.toString() ?? '0'))}"),
                                  const Hg(
                                    height: 2,
                                  ),
                                  TextWidget(
                                      txt:
                                          "Qarzi dollorda: ${moneyFormatterWidthDollor(double.parse(state.data[0].debts?.allDollar.toString() ?? '0'))}"),
                                ],
                              ),
                            ),
                          )
                        : SizedBox();
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OneButton(
                width: double.infinity,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () {
                  showMobileDialogWidget(
                    context,
                    MobileAddDebtUI(
                      forCustomer: true,
                      id: widget.id,
                    ),
                    1.2,
                    2,
                  );
                },
                label: "Qarz yozish",
              ),
            )
          ],
        ),
      ),
    );
  }
}
