import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'line_title.dart';

class LineChartWidget extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xffFCAA0B),
    const Color(0xffFCAA0B),
  ];

  @override
  Widget build(BuildContext context) => LineChart(
    LineChartData(
      maxX: 12,
      minX: 0,
      maxY: 6,
      minY: 0,
      titlesData: LineTitles.getInvalidTitlesData(),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(1, 3),
            const FlSpot(2.6, 2),
            const FlSpot(4.9, 5),
            const FlSpot(6.8, 2.5),
            const FlSpot(8, 4),
            const FlSpot(9.5, 3),
            const FlSpot(11, 4),
          ],
          color: gradientColors.first,
          barWidth: 5,
        )
      ],
    ),
  );
}

class EnterLineChartWidget extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff16DBCC),
  ];

  EnterLineChartWidget({super.key});

  @override
  Widget build(BuildContext context) => LineChart(
    LineChartData(
      maxX: 12,
      minX: 0,
      maxY: 6,
      minY: 0,
      titlesData: LineTitles.getInvalidTitlesData(),

      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(2, 3),
            const FlSpot(2.6, 2),
            const FlSpot(4.9, 5),
            const FlSpot(6.8, 2.5),
            const FlSpot(8, 4),
            const FlSpot(9.5, 3),
            const FlSpot(11, 4),
          ],
          isCurved: true,
          color: gradientColors.first,
          barWidth: 5,
        )
      ],
    ),
  );
}
