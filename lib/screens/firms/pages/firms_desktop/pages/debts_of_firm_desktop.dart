import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/screens/customer/widgets/pay_off_debt.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/screens/firms/pages/widgets/debt_update.dart';
import 'package:santexnika_crm/screens/firms/pages/widgets/of_scrollbar_page/of_scrollbar_products.dart';
import 'package:santexnika_crm/screens/store/pages/desktop/store_desktop/widget/store_add.dart';
import 'package:santexnika_crm/tools/check_price.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../../tools/appColors.dart';
import '../../../../../tools/format_date_time.dart';
import '../../../../../tools/money_formatter.dart';
import '../../../../../widgets/data_table.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/data_culumn_text.dart';
import '../../../../../widgets/text_widget/data_row_text.dart';
import '../../widgets/debt_repayment.dart';
import '../../widgets/of_scrollbar_page/of_scrollbar_debts_screen.dart';

class DebtsOfTheFirm extends StatefulWidget {
  final VoidCallback onTap;
  final String? name;
  final int id;

  const DebtsOfTheFirm(
      {super.key, required this.onTap, this.name, required this.id});

  @override
  State<DebtsOfTheFirm> createState() => _DebtsOfTheFirmState();
}

class _DebtsOfTheFirmState extends State<DebtsOfTheFirm> {
  int? id;
  int toggleIndex = 0;

  @override
  Widget build(BuildContext context) {
    print(toggleIndex);

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
                children: [
                  TextWidget(txt: "${widget.name}ning qarz tarixi"),
                  Row(
                    children: [
                      ButtonWidget(
                        width: 200,
                        icon: Icons.add,
                        label: "Qarz qo'shish",
                        onTap: () {
                          showCustomDialogWidget(
                            context,
                            AddDebtDesktopUI(
                              forCustomer: false,
                              id: widget.id,
                            ),
                            3,
                            2,
                          );
                        },
                      ),
                      const Wd(),
                      // ButtonWidget(
                      //   width: 280,
                      //   label: "Mahsulot Qo`shish",
                      //   icon: Icons.add,
                      //   onTap: () {
                      //     showCustomDialogWidget(
                      //       context,
                      //       const StoreAddWidget(),
                      //       2.5,
                      //       1.3,
                      //     );
                      //   },
                      // ),
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
                  )
                ],
              ),
            ),
          ),
          const Hg(
            height: 3,
          ),
          Container(
            color: AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scrollbar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleSwitch(
                      minWidth: 200.0.w,
                      activeBgColor: [
                        AppColors.selectedColor,
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: AppColors.toqPrimaryColor,
                      inactiveFgColor: AppColors.whiteColor,
                      initialLabelIndex: toggleIndex,
                      totalSwitches: 2,
                      labels: const [
                        "Qarzlar",
                        "Tovarlar",
                      ],
                      onToggle: (v) {
                        toggleIndex = v!;

                        if (toggleIndex == 0) {
                          context
                              .read<ShowCompanyCubit>()
                              .showCompany(widget.id);
                        }

                        if (toggleIndex == 1) {
                          context
                              .read<ShowCompanyCubit>()
                              .getAttachedProducts(widget.id,1 );
                        }
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          const Hg(
            height: 3,
          ),
          if (toggleIndex == 0)
            //for debts
            DesktopOFScrollbarDebtsScreen(
              id: widget.id,
            ),
          if (toggleIndex == 1)
            //for product
            DesktopOFScrollbarProducts(
              id: widget.id,
            ),
        ],
      ),
    );
  }
}
