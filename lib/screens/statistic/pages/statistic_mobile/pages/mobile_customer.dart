import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/statistic/cubits/statistic_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/statistic_bar.dart';

import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../widget/pie_chart.dart';

class MobilCustomerStatisticUI extends StatefulWidget {
  const MobilCustomerStatisticUI({super.key});

  @override
  State<MobilCustomerStatisticUI> createState() =>
      _MobilCustomerStatisticUIState();
}

class _MobilCustomerStatisticUIState extends State<MobilCustomerStatisticUI> {
  List<String> name = [
    "Eng ko'p savdo qilgan xaridor (Soni)",
    "Eng ko'p savdo qilgan xaridor So'm",
    "Eng ko'p savdo qilgan xaridor Dollar",
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<StatisticCubit>().getCustomerStatistic();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Column(
        children: [
          const StatisticBarWidget(name: "Xaridorlar"),
          BlocBuilder<StatisticCubit, StatisticState>(
            builder: (context, state) {
              if (state is StatisticLoading) {
                return const ApiLoadingWidget();
              } else if (state is StatisticError) {
                return Center(
                  child: TextWidget(txt: state.error),
                );
              } else if (state is StatisticSuccessCustomer) {
                var dataMap = state.data;
                return Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: name.length,
                      itemBuilder: (context, index) {
                        Map<String, double> data = {};
                        if (index == 0) {
                          for (var e in dataMap.customers) {
                            data["${e.name} ${e.count} ta"] =
                                double.tryParse(e.count.toString()) ?? 0;
                          }
                        } else if (index == 1) {
                          for (var e in dataMap.customersByPrice) {
                            data["${e.name} ${e.totalSum}"] =
                                double.tryParse(e.totalSum.toString()) ?? 0;
                          }
                        } else {
                          for (var e in dataMap.customersByPrice) {
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
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
