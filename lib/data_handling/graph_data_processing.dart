import 'dart:io';
import 'package:desktop_application/data_handling/csv_communication.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

Future<List<FlSpot>> loadGraphData() async {
  // Open last-created file
  final directory = Directory.current;
  final files = await directory
      .list()
      .where((entity) => entity is File && entity.path.endsWith('.csv'))
      .toList();

  if (files.isEmpty) return [];

  files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
  String lastFileName = files.first.path;

  List<DataEntry> csvData = await loadFromCsv(lastFileName);

  // Convert CSV data to FlSpot
  List<FlSpot> flSpots = csvData.map((dataEntry) {
    // Assuming the first column is timestamp and the second is the value
    // You might need to adjust indices based on your CSV structure
    // debugPrint('X: $xStr, y: $yStr');
    return FlSpot(dataEntry.timeValue, dataEntry.peak2Peak);
  }).toList();

  return flSpots;
}

List createLabels(dataEntries, graphXView) {
  // take only data you ,view (for minute_view take one minute, for day_view, take one day)
  return [];
}
