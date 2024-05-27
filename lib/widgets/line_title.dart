import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
 
import 'line_text.dart';

class LineTitles {
  static getInvalidTitlesData() => FlTitlesData(
    show: true,
    topTitles: const AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
      ),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 20,
        getTitlesWidget: (value, titleMeta) {
          switch (value.toInt()) {
            case 1:
              return const TextWidgetLine(txt: '10',txtColor: Colors.white,);
            case 3:
              return const TextWidgetLine(txt: '20',txtColor: Colors.white,);
            case 5:
              return const TextWidgetLine(txt: '20',txtColor: Colors.white,);
            default:
              return const Text('');
          }
        },

      ),

    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 22,
        interval: 2,
        showTitles: true,
        getTitlesWidget: (value, titleMeta) {
          switch (value.toInt()) {
            case 0:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Jan',txtColor: Colors.white,),
              );
            case 1:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Fev',txtColor: Colors.white,),
              );
            case 2:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Mar',txtColor: Colors.white,),
              );
            case 3:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Apr',txtColor: Colors.white,),
              );
            case 4:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'May',txtColor: Colors.white,),
              );
            case 5:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Iyul',txtColor: Colors.white,),
              );
            case 6:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Iyun',txtColor: Colors.white,),
              );
            case 7:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Avgust',txtColor: Colors.white,),
              );
            case 8:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Sep',txtColor: Colors.white,),
              );
            case 9:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Ok',txtColor: Colors.white,),
              );
            case 10:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Nov',txtColor: Colors.white,),
              );
            case 11:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextWidgetLine(txt: 'Dec',txtColor: Colors.white,),
              );
            default:
              return const Text('');
          }
        },
      ),
    ),
  );

  static getEnterTitlesData() => FlTitlesData(
    show: true,
    topTitles: const AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
      ),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 20,
        getTitlesWidget: (value, titleMeta) {
          switch (value.toInt()) {
            case 1:
              return const Text('10');
            case 3:
              return const Text('30');
            case 5:
              return const Text('30');
            default:
              return const Text('');
          }
        },

      ),

    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 22,
        interval: 2,
        showTitles: true,
        getTitlesWidget: (value, titleMeta) {
          switch (value.toInt()) {
            case 0:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Jan'),
              );
            case 1:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Feb'),
              );
            case 2:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Mar'),
              );
            case 3:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Apr'),
              );
            case 4:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('May'),
              );
            case 5:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Jun'),
              );
            case 6:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Jul'),
              );
            case 7:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Aug'),
              );
            case 8:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Sep'),
              );
            case 9:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Oct'),
              );
            case 10:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Nov'),
              );
            case 11:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Dec'),
              );
            default:
              return const Text('');
          }
        },
      ),
    ),
  );
}
