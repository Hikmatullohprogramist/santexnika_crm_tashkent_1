import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/models/statistic/store.dart';
import 'package:santexnika_crm/models/statistic/trade.dart';
import 'package:santexnika_crm/screens/statistic/cubits/statistic_cubit.dart';
import 'package:santexnika_crm/screens/store/cubit/store_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/bar_text_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';
import '../../../../models/statistic/kassa.dart';
import '../../../../tools/money_formatter.dart';
import '../../widget/pie_chart.dart';

class StatisticDiagramStorePage extends StatefulWidget {
  final UserStores dataMap;

  const StatisticDiagramStorePage({
    Key? key,
    required this.dataMap,
  }) : super(key: key);

  @override
  State<StatisticDiagramStorePage> createState() =>
      _StatisticDiagramStorePageState();
}

class _StatisticDiagramStorePageState extends State<StatisticDiagramStorePage> {
  List<String> name = [
    "Eng kop sotilayotgan tovarlar",
    "Eng kam sotilayotgan tovarlar",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<StoreCubit, StoreState>(
              builder: (context, state) {
                if (state is StoreCalculateSuccessState) {
                  return SizedBox(
                    height: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  txt: "Tovarlar soni:",
                                  size: 14.sp,
                                ),
                                TextWidget(
                                  txt: state.data.count.toString(),
                                  size: 14.sp,
                                ),
                              ],
                            ),
                            BarTextWidgets(
                                name: "Ombordagi tovarlar (So`m)",
                                price: double.parse(
                                    state.data.calculateSum.toString())),
                            BarTextWidgets(
                                name: "Ombordagi tovarlar (Dollar)",
                                price: double.parse(
                                    state.data.calculateDollar.toString())),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BarTextWidgets(
                                name:
                                    "Ombordagi jami tovarlardan taxminiy sotiladigan (So`m)",
                                price: double.parse(
                                    state.data.totalSum.toString())),
                            BarTextWidgets(
                                name:
                                    "Ombordagi jami tovarlardan taxminiy sotiladigan (Dollar)",
                                price: double.parse(
                                    state.data.totalDollar.toString())),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            Hg(),
            BlocBuilder<StatisticCubit, StatisticState>(
              builder: (context, state) {
                if (state is StatisticTradeAndStoreState) {
                  return _buildTradePage(state);
                }
                return const SizedBox();
              },
            ),
            Hg(),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: name.length,
              itemBuilder: (context, index) {
                Map<String, double> data = {};
                switch (index) {
                  case 0:
                    for (var e in widget.dataMap.storesMoreSelled) {
                      data["${e.name} ${e.count} ta"] =
                          double.tryParse(e.count.toString()) ?? 0;
                    }
                    break;
                  case 1:
                    for (var e in widget.dataMap.storesLessSelled) {
                      data["${e.name} ${e.count} ta\nOmborda ${e.quantity}"] =
                          double.tryParse(e.count.toString()) ?? 0;
                    }
                    break;
                  default:
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
                mainAxisExtent: 600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradePage(StatisticState state) {
    if (state is StatisticTradeAndStoreState) {
      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.data.length,
        itemBuilder: (context, index) {
          var data = state.data[index];
          return _buildTradeCard(data);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 350,
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildStatItem(String title, num value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          moneyFormatter(double.parse(value.toString())),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTradeCard(KassaStatistic data) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        color: AppColors.primaryColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                txt: 'Filial nomi: ${data.name}',
              ),
              const SizedBox(height: 20),
              _buildStatItem(
                'Ombordagi tovar (So`m)',
                data.sumCome ?? 0.0,
              ),
              _buildStatItem(
                'Ombordagi tovar (Dollar)',
                data.dollarCome ?? 0.0,
              ),
              Divider(),
              _buildStatItem(
                'Naqd (So`m)',
                data.kassaUzsNaqd ?? 0.0,
              ),
              _buildStatItem(
                'Naqd (Dollar)',
                data.kassaUsd ?? 0.0,
              ),
              _buildStatItem(
                'Kartada',
                data.kassaUzsPlastik ?? 0.0,
              ),
              _buildStatItem(
                'Click (Dollar)',
                data.kassaUzsClick ?? 0.0,
              ),
              Divider(),
              _buildStatItem(
                'Ombordagi tovarlar sotilsa (Dollar)',
                data.dollarSell ?? 0.0,
              ),
              _buildStatItem(
                'Ombordagi tovarlar sotilsa (So`m)',
                data.sumSell ?? 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
