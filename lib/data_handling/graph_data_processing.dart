import 'dart:io';
import 'package:desktop_application/cubits/settings_cubit/settings_cubit.dart';
import 'package:desktop_application/data_handling/csv_communication.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//

Future<List<FlSpot>> loadGraphData({required BuildContext context}) async {
  // Open last-created file
  final directory = Directory.current;
  final files = await directory
      .list()
      .where((entity) => entity is File && entity.path.endsWith('.csv'))
      .toList();

  if (files.isEmpty) return [];

  files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
  String lastFileName = files.first.path;

  List<DataEntry> csvData = await loadFromCsv(lastFileName, context: context);

  // Convert CSV data to FlSpot
  List<FlSpot> flSpots = csvData.map((dataEntry) {
    // Assuming the first column is timestamp and the second is the value
    // You might need to adjust indices based on your CSV structure
    // debugPrint('X: $xStr, y: $yStr');
    return FlSpot(dataEntry.timeValue, dataEntry.peak2Peak);
  }).toList();

  return flSpots;
}

List createLabels(List<DataEntry> dataEntries, BuildContext context) {
  final graphXView = context.read<SettingsCubit>().state.graphXView;
  int subListSize = (dataEntries.length / 12).ceil();
  List<String> xLabels = [];
  switch (graphXView) {
    case GraphXView.MINUTE:
      xLabels.add(dataEntries.first.dateTime.toString().substring(14,
          19)); // dateFormat: 2024-07-09 11:10:12.244683 -> substring(14,19) 10:12 min:sec
      for (int i = 0; i < 12; i++) {
        // int currentIndex = min(subListSize * i, dataEntries.length);
        xLabels.add(
            dataEntries[i * subListSize].dateTime.toString().substring(14, 19));
      }

      // Add logic for minute view
      break;
    case GraphXView.HOUR:
      print('Displaying data in hour view');
      // Add logic for hour view
      break;
    case GraphXView.SIX_HOURS:
      print('Displaying data in six-hour view');
      // Add logic for six-hour view
      break;
    case GraphXView.DAY:
      print('Displaying data in day view');
      // Add logic for day view
      break;
    case GraphXView.SIX_DAYS:
      print('Displaying data in six-day view');
      // Add logic for six-day view
      break;
  }
  // take only data you ,view (for minute_view take one minute, for day_view, take one day)
  return xLabels;
}
