import 'package:flutter/material.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/line_chart.dart';

import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/statistic_bar.dart';

class MobileCashBoxStatisticUI extends StatefulWidget {
  const MobileCashBoxStatisticUI({super.key});

  @override
  State<MobileCashBoxStatisticUI> createState() =>
      _MobileCashBoxStatisticUIState();
}

class _MobileCashBoxStatisticUIState extends State<MobileCashBoxStatisticUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Column(
        children: [
          const StatisticBarWidget(
            name: 'Kassa',
          ),
          const Hg(
            height: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Hg(),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // Set scroll direction to horizontal
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.borderColor,
                            ),
                          ),
                          child: LineChartWidget(),
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      // Set the height of each item
                      mainAxisExtent: 300,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
