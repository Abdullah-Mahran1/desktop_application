import 'dart:math';

import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/const/data_singleton.dart';
import 'package:desktop_application/data_handling/graph_data_processing.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class MyLineChart extends StatelessWidget {
//   const MyLineChart({
//     Key? key,
//     required this.flSpots,
//     required this.graphXView,
//   }) : super(key: key);

//   final List<FlSpot> flSpots;
//   final GraphXView graphXView;

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 10,
//     );
//     String text;
//     try {
//       text = generateLabel(value, graphXView);
//       debugPrint('Generated label: $text for value: $value');
//     } catch (e) {
//       debugPrint('Error generating label: $e');
//       text = 'Error';
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(text, style: style),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     debugPrint('Building MyLineChart with ${flSpots.length} data points');
//     return AspectRatio(
//       aspectRatio: 1.5,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           debugPrint('LayoutBuilder constraints: $constraints');
//           return SizedBox(
//             height: 200,
//             width: constraints.maxWidth,
//             child: _buildChart(),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildChart() {
//     try {
//       return LineChart(
//         LineChartData(
//           lineBarsData: [
//             LineChartBarData(
//               spots: flSpots,
//               isCurved: true,
//               color: Colors.blue,
//               barWidth: 2,
//               isStrokeCapRound: true,
//               dotData: const FlDotData(show: false),
//             ),
//           ],
//           titlesData: FlTitlesData(
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 22,
//                 getTitlesWidget: bottomTitleWidgets,
//                 interval: calculateInterval(flSpots.length),
//               ),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           ),
//           gridData: FlGridData(show: true),
//           borderData: FlBorderData(show: true),
//           minY: calculateMinY(),
//           maxY: calculateMaxY(),
//         ),
//       );
//     } catch (e) {
//       debugPrint('Error building chart: $e');
//       return Center(child: Text('Error: Unable to build chart'));
//     }
//   }

//   double calculateInterval(int dataLength) {
//     debugPrint('Calculating interval for $dataLength data points');
//     if (dataLength > 1000) return 100;
//     if (dataLength > 500) return 50;
//     if (dataLength > 100) return 10;
//     return 1;
//   }

//   double calculateMinY() {
//     if (flSpots.isEmpty) {
//       debugPrint('Warning: flSpots is empty');
//       return 0;
//     }
//     return flSpots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
//   }

//   double calculateMaxY() {
//     if (flSpots.isEmpty) {
//       debugPrint('Warning: flSpots is empty');
//       return 1;
//     }
//     return flSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
//   }
// }

class MyLineChart2 extends StatelessWidget {
  const MyLineChart2({super.key, required this.context, required this.flSpots});
  final List<FlSpot> flSpots;
  final BuildContext context;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    //value template: 20240709091259355000.0
    String axisNumber = DataSingleton().xView ?? 'MINUTE';
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    debugPrint('BTW val: $axisNumber');

    // try {
    //   // Calculate the interval for evenly distributed labels
    //   double interval = flSpots.length / 12;
    //   if ((value % interval).abs() < interval / 2) {
    //     int index = value.toInt();
    //     if (index >= 0 && index < flSpots.length) {
    //       text = index.toString().substring(0, index.toString().length);
    //     }
    //   }
    //   debugPrint('Generated label: $text for value: $value');
    // } catch (e) {
    //   debugPrint('Error generating label: $e');
    //   text = 'Error';
    // }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(axisNumber, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building MyLineChart2 with ${flSpots.length} data points');
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: flSpots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              belowBarData: BarAreaData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text('Time interval'),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitleWidgets,
                interval: max((flSpots.length / 10).ceil().toDouble(), 1000),
                // reservedSize: 22,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
