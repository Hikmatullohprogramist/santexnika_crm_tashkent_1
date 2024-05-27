import 'package:flutter/material.dart';
import 'package:santexnika_crm/models/statistic/store.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/column_text_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../widget/pie_chart.dart';

class MobileProductWidget extends StatefulWidget {
  final UserStores dataMap;

  const MobileProductWidget({super.key, required this.dataMap});

  @override
  State<MobileProductWidget> createState() => _MobileProductWidgetState();
}

class _MobileProductWidgetState extends State<MobileProductWidget> {
  List<String> name = [
    "Eng kop sotilayotgan tovarlar",
    "Eng kam sotilayotgan tovarlar",
  ];
  Map<String, double> data = {};

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.successColor,
                    border: Border.all(color: AppColors.borderColor)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      RowsTextWidget(
                        title: "Tovarlar soni ",
                        name: '1000',
                      ),
                      Hg(),
                      RowsTextWidget(
                        title: "Ombordagi tovarlar (So`m): ",
                        name: '1000',
                      ),
                      Hg(),
                      RowsTextWidget(
                        title: "Ombordagi tovarlar (Dollor): ",
                        name: '1000',
                      ),
                      Hg(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ColumnTextWidget(
                              title:
                                  "Ombordagi jami tovarlardan taxminiy foyda (So`m):",
                              name: '100',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ColumnTextWidget(
                              title:
                                  "Ombordagi jami tovarlardan taxminiy foyda (Dollor):",
                              name: '100',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // Set scroll direction to horizontal
              itemCount: name.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  widget.dataMap.storesMoreSelled.forEach((e) {
                    data["${e.name} ${e.quantity} ta"] =
                        double.tryParse(e.count.toString()) ?? 0;
                  });
                } else {
                  widget.dataMap.storesLessSelled.forEach((e) {
                    data["${e.name} ${e.quantity} ta"] =
                        double.tryParse(e.count.toString()) ?? 0;
                  });
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            color: AppColors.primaryColor,
                            child: Center(
                              child: TextWidget(
                                txt: name[index],
                              ),
                            ),
                          ),
                          const Hg(),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: PieChartUI(
                              dataMap: data,
                              forDesktop: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
