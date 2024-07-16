import 'package:desktop_application/cubits/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';

class DataEntry {
  DateTime dateTime;
  double timeValue = 0; // X-axis value not label
  final double min, max, average, peak2Peak;

  DataEntry(
      {required this.dateTime,
      required this.min,
      required this.max,
      required this.average,
      required this.peak2Peak}) {
    timeValue =
        double.parse(dateTime.toString().replaceAll(RegExp(r'[^\d]'), ''));
  }
  List<String> toCSVRow() {
    return [
      dateTime.toString(),
      min.toString(),
      max.toString(),
      average.toString(),
      peak2Peak.toString()
    ];
  }

  @override
  String toString() {
    return 'DateTime: $dateTime, $min < $average < $max, Peak2Peak: $peak2Peak';
  }

  static String generateLabel(DateTime dateTime, GraphXView graphXView) {
    String formattedValue;

    switch (graphXView) {
      case GraphXView.MINUTE:
        // Show minutes and seconds
        formattedValue =
            '${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
      case GraphXView.HOUR:
      case GraphXView.SIX_HOURS:
        // Show hours and minutes
        formattedValue =
            '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      case GraphXView.DAY:
      case GraphXView.SIX_DAYS:
        // Show days and hours
        // Note: This assumes you want the day of the month. If you need something else, like days elapsed, you'll need to calculate that separately.
        formattedValue =
            '${dateTime.day.toString().padLeft(2, '0')}:${dateTime.hour.toString().padLeft(2, '0')}';
      default:
        // Default to a full date-time string if no case matches
        formattedValue = dateTime.toString();
    }

    debugPrint(
        'dateTime: $dateTime, graphXView: $graphXView, formattedValue: $formattedValue');
    return formattedValue;
  }

  // double generatedValues(GraphXView graphXView) {
  //   // value template: 20240709091259355000.0 (minute: (8,10):(10,12)) (hour: ():())
  //   String sValue = timeValue.toInt().toString();
  //   // This is a placeholder implementation. You'll need to adjust this ba sed on your actual data and requirements.
  //   switch (graphXView) {
  //     case GraphXView.MINUTE:
  //       // Assuming value represents minutes past the hour
  //       return double.parse(
  //           '${sValue.substring(10, 12)}${sValue.substring(12, 14)}');
  //     case GraphXView.HOUR:
  //     case GraphXView.SIX_HOURS:
  //       // Assuming value represents hours
  //       return double.parse(
  //           '${sValue.substring(8, 10)}${sValue.substring(10, 12)}');
  //     case GraphXView.DAY:
  //     case GraphXView.SIX_DAYS:
  //       // Assuming value represents days
  //       return double.parse(
  //           '${sValue.substring(6, 8)}${sValue.substring(8, 10)}');
  //     default:
  //       return double.parse(timeValue.toStringAsFixed(0));
  //   }
  // }
}
