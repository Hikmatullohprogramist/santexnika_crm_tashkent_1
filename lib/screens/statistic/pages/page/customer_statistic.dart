import 'package:flutter/material.dart';
import 'package:santexnika_crm/models/statistic/customer.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../widget/pie_chart.dart';

class StatisticDiagramCustomerPage extends StatefulWidget {
  final CustomersData dataMap;

  const StatisticDiagramCustomerPage({Key? key, required this.dataMap})
      : super(key: key);

  @override
  State<StatisticDiagramCustomerPage> createState() =>
      _StatisticDiagramCustomerPageState();
}

class _StatisticDiagramCustomerPageState
    extends State<StatisticDiagramCustomerPage> {
  List<String> name = [
    "Eng ko'p savdo qilgan xaridor (Soni)",
    "Eng ko'p savdo qilgan xaridor So'm",
    "Eng ko'p savdo qilgan xaridor Dollar",
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: name.length,
      itemBuilder: (context, index) {
        Map<String, double> data = {};
        if (index == 0) {
          for (var e in widget.dataMap.customers) {
            data["${e.name} ${e.count} ta"] =
                double.tryParse(e.count.toString()) ?? 0;
          }
        } else if (index == 1) {
          for (var e in widget.dataMap.customersByPrice) {
            data["${e.name} ${e.totalSum}"] =
                double.tryParse(e.totalSum.toString()) ?? 0;
          }
        } else {
          for (var e in widget.dataMap.customersByPrice) {
            data["${e.name} ${e.totalDollar} \$"] =
                double.tryParse(e.totalDollar.toString()) ?? 0;
          }
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
                    height: 500,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: PieChartUI(dataMap: data),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // Set the height of each item
        mainAxisExtent: 600,
      ),
    );
  }
}
