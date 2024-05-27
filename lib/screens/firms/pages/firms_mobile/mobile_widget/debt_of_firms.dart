import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/customer/pages/customer_mobile/widget/add_debt.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile/one_button.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';

import '../../../../../tools/appColors.dart';
import '../../../../../tools/check_price.dart';
import '../../../../../tools/format_date_time.dart';
import '../../../../../widgets/background_widget.dart';
import '../../../../../widgets/text_widget/rows_text_widget.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../../customer/pages/customer_mobile/widget/mobile_update _debt.dart';
import '../../../../customer/pages/customer_mobile/widget/pay_of_debt.dart';

class MobileDebtOfFirms extends StatefulWidget {
  final String? name;
  final int id;

  const MobileDebtOfFirms({super.key, this.name, required this.id});

  @override
  State<MobileDebtOfFirms> createState() => _MobileDebtOfFirmsState();
}

class _MobileDebtOfFirmsState extends State<MobileDebtOfFirms> {
  int? selectedValuee;
  int? typesId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        title: TextWidget(txt: "${widget.name} ning qarz tarixi"),
      ),
      backgroundColor: AppColors.bottombarColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            BlocBuilder<ShowCompanyCubit, ShowCompanyState>(
              builder: (BuildContext context, state) {
                if (state is ShowCompanyLoadingState) {
                  return const Expanded(child: ApiLoadingWidget());
                } else if (state is ShowCompanyErrorState) {
                  return Expanded(
                    child: Center(
                      child: MobileAPiError(
                        message: state.error,
                        onTap: () {
                          context.read<ShowCompanyCubit>().showCompany(
                                widget.id!,
                              );
                        },
                      ),
                    ),
                  );
                } else if (state is ShowCompanySuccessState) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.data.data.length,
                      itemBuilder: (context, index) {
                        var data = state.data.data![index];
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (v) {
                                  showMobileDialogWidget(
                                    context,
                                    MobileDebtUpdate(
                                      forCustomer: false,
                                      id: widget.id,
                                      debtId: data.id!,
                                      selectedValuee: data.priceId,
                                      comment: data.comment,
                                      selectedTypesValuee: data.typeId,
                                      price: data.price,
                                    ),
                                    1.2,
                                    1.7,
                                  );
                                },
                                backgroundColor: AppColors.selectedColor,
                                icon: Icons.edit,
                                foregroundColor: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              SlidableAction(
                                onPressed: (v) {
                                  mobileDeletedDialog(
                                    context,
                                    () {
                                      context
                                          .read<ShowCompanyCubit>()
                                          .deletePayCompany(
                                            data.id!,
                                            data.companyId!,
                                          );
                                      context
                                          .read<ShowCompanyCubit>()
                                          .showCompany(
                                            data.companyId!,
                                          );
                                      Get.back();
                                    },
                                  );
                                },
                                backgroundColor: AppColors.errorColor,
                                icon: Icons.delete,
                                foregroundColor: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: MobileBackgroundWidget(
                              onTap: () {
                                showMobileDialogWidget(
                                  context,
                                  MobilePayOfDebt(
                                    forCustomer: false,
                                    id: widget.id,
                                  ),
                                  1.2,
                                  1.7,
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
                                    title: "Pul tuir: ",
                                    name: '${checkPrice(
                                      data.priceId ?? 0,
                                    )}',
                                  ),
                                  const Hg(),
                                  RowsTextWidget(
                                    title: "",
                                    name: data.typeId != 4
                                        ? "To'langan"
                                        : "Qarzdorlik",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Hg(height: 2,),
            BlocBuilder<ShowCompanyCubit, ShowCompanyState>(
              builder: (BuildContext context, state) {
                if (state is ShowCompanyLoadingState) {
                  return const SizedBox();
                } else if (state is ShowCompanyErrorState) {
                  return SizedBox();
                } else if (state is ShowCompanySuccessState) {
                  return Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget(
                              txt:
                                  "Qarzi so'mda: ${moneyFormatter(double.parse(state.data.debtsSum.toString() ?? '0'))}"),
                          const Hg(
                            height: 2,
                          ),
                          TextWidget(
                              txt:
                                  "Qarzi dollorda: ${moneyFormatterWidthDollor(double.parse(state.data.debtsDollar.toString() ?? '0'))}"),
                        ],
                      ),
                    ),
                  );
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
                      forCustomer: false,
                      id: widget.id,
                    ),
                    1.2,
                    1.7,
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
