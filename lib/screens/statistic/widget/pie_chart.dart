
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartUI extends StatefulWidget {
  final Map<String, double> dataMap;
  final bool?forDesktop;
  const PieChartUI({super.key, required this.dataMap, this.forDesktop});

  @override
  State<PieChartUI> createState() => _PieChartUIState();
}

class _PieChartUIState extends State<PieChartUI> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PieChart(
        dataMap: widget.dataMap,
        chartRadius: MediaQuery.sizeOf(context).width / 1.7,
        legendOptions:  LegendOptions(
          legendPosition: widget.forDesktop??true?LegendPosition.right:LegendPosition.bottom,
          legendTextStyle: TextStyle(color: Colors.white),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 1,        ),
        centerTextStyle: const TextStyle(color: Colors.white),
        chartType: ChartType.disc,

      ),
    );
  }
}
