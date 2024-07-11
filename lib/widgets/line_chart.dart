import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/cubits/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyLineChart extends StatelessWidget {
  final List data;
  final GraphXView scale;

  const MyLineChart({
    super.key,
    required this.data,
    this.scale = GraphXView.HOUR, // Provide a default value
  });
  @override
  Widget build(BuildContext context) {
    final processedData = getProcessedData(data, scale);

    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: processedData,
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) => getBottomTitles(value, scale),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (value, meta) =>
                    Text(value.toStringAsFixed(1)),
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }

  List<FlSpot> getProcessedData(List data, GraphXView scale) {
    final processor = TimeBasedDataProcessor(serverReadingDelay);

    List<FlSpot> spots = data.map((row) {
      return FlSpot(row[0].toDouble(), row[1].toDouble());
    }).toList();

    return processor.processData(spots, scale);
  }

  Widget getBottomTitles(double value, GraphXView scale) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    String text;
    switch (scale) {
      case GraphXView.MINUTE:
        text = '${date.minute}m';
        break;
      case GraphXView.HOUR:
      case GraphXView.SIX_HOURS:
        text = '${date.hour}h';
        break;
      case GraphXView.DAY:
      case GraphXView.SIX_DAYS:
        text = '${date.day}d';
        break;
    }
    return Text(text, style: const TextStyle(fontSize: 10));
  }
}

class TimeBasedDataProcessor {
  final int serverReadingDelay; // in milliseconds

  TimeBasedDataProcessor(this.serverReadingDelay);

  int _getRequiredDataPoints(GraphXView scale) {
    final pointsPerMinute = 60000 ~/ serverReadingDelay; // 60000 ms in a minute
    switch (scale) {
      case GraphXView.MINUTE:
        return pointsPerMinute;
      case GraphXView.HOUR:
        return pointsPerMinute * 60;
      case GraphXView.SIX_HOURS:
        return pointsPerMinute * 60 * 6;
      case GraphXView.DAY:
        return pointsPerMinute * 60 * 24;
      case GraphXView.SIX_DAYS:
        return pointsPerMinute * 60 * 24 * 6;
    }
  }

  List<FlSpot> processData(List<FlSpot> originalData, GraphXView scale) {
    final requiredPoints = _getRequiredDataPoints(scale);
    final processedData = List<FlSpot>.filled(requiredPoints, FlSpot(0, 0));

    if (originalData.isEmpty) {
      return processedData;
    }

    if (originalData.length >= requiredPoints) {
      // Take the latest elements
      return originalData.sublist(originalData.length - requiredPoints);
    } else {
      // Fill with original data and pad with zeros
      final lastTimestamp = originalData.last.x;
      final timeStep = serverReadingDelay.toDouble();

      for (int i = 0; i < requiredPoints; i++) {
        if (i < originalData.length) {
          processedData[requiredPoints - originalData.length + i] =
              originalData[i];
        } else {
          final timestamp =
              lastTimestamp + (i - originalData.length + 1) * timeStep;
          processedData[i] = FlSpot(timestamp, 0);
        }
      }
      return processedData;
    }
  }
}
