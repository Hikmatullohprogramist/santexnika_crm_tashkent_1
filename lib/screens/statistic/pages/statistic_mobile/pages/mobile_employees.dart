import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/widgets/statistic_bar.dart';

import '../../../../../tools/appColors.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../cubits/statistic_cubit.dart';
import '../../../widget/pie_chart.dart';

class MobileEmployeesStatisticUI extends StatefulWidget {
  const MobileEmployeesStatisticUI({
    super.key,
  });

  @override
  State<MobileEmployeesStatisticUI> createState() =>
      _MobileEmployeesStatisticUIState();
}

class _MobileEmployeesStatisticUIState
    extends State<MobileEmployeesStatisticUI> {
  List<String> name = [
    "Eng ko'p savdo qilgan sotuvchi (Soni)",
    "Eng ko'p savdo qilgan sotuvchi So'm",
    "Eng ko'p savdo qilgan sotuvchi Dollar",
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<StatisticCubit>().getUserStatistic();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Column(
        children: [
          const StatisticBarWidget(name: "Xodimlar"),
          BlocBuilder<StatisticCubit, StatisticState>(
            builder: (context, state) {
              if (state is StatisticLoading) {
                return const ApiLoadingWidget();
              } else if (state is StatisticError) {
                return Center(
                  child: TextWidget(txt: state.error),
                );
              } else if (state is StatisticSuccessUsers) {
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
                          for (var e in dataMap.users) {
                            data["${e.name} ${e.count} ta"] =
                                double.tryParse(e.count.toString()) ?? 0;
                          }
                        } else if (index == 1) {
                          for (var e in dataMap.usersByPrice) {
                            data["${e.name} ${e.totalSum}"] =
                                double.tryParse(e.totalSum.toString()) ?? 0;
                          }
                        } else {
                          for (var e in dataMap.usersByPrice) {
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
