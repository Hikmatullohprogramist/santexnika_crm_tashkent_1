import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/data_culumn_text.dart';
import 'package:santexnika_crm/widgets/text_widget/data_row_text.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../tools/appColors.dart';
import '../../../widgets/data_table.dart';

class DesktopHisobotTarixiDialog extends StatelessWidget {
  const DesktopHisobotTarixiDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.bottombarColor,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.3,
          height: MediaQuery.of(context).size.height / 1.6,
          decoration: BoxDecoration(
            color: AppColors.bottombarColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        color: AppColors.primaryColor,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextWidget(txt: "title qoyish kerak: 123"),
                      )),
                  const Hg(
                    height: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: AppColors.primaryColor,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: const DataTableWidget(
                      dataColumn: [
                        DataColumn(label: DataColumnText(txt: 'id')),
                        DataColumn(label: DataColumnText(txt: 'Nomi')),
                        DataColumn(label: DataColumnText(txt: 'Miqdori')),
                        DataColumn(
                            label: DataColumnText(txt: 'Kelishilgan summasi')),
                        DataColumn(label: DataColumnText(txt: 'Sotuvchi')),
                        DataColumn(label: DataColumnText(txt: 'Sana')),
                      ],
                      dataRow: [
                        DataRow(
                          cells: [
                            DataCell(
                              DataRowText(txt: "txt"),
                            ),
                            DataCell(
                              DataRowText(txt: "txt"),
                            ),
                            DataCell(
                              DataRowText(txt: "txt"),
                            ),
                            DataCell(
                              DataRowText(txt: "txt"),
                            ),
                            DataCell(
                              DataRowText(txt: "txt"),
                            ),
                            DataCell(
                              DataRowText(txt: "txt"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: AppColors.primaryColor,
                ),
                child:  Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonWidget(
                        width: 220,
                        label: "Bekor qilish",
                        icon: Icons.exit_to_app,
                        onTap: (){
                          Get.back();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
