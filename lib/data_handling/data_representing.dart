import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> readExcelData(String filePath) async {
  // Load the CSV file
  var csvData;
  try {
    csvData = await rootBundle.loadString(filePath);
  } catch (e) {
    debugPrint('Error loading CSV file: $e');
    // Handle the error, maybe show a dialog to the user
    return;
  }
  // Parse the CSV data
  List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);

  // Extract the first and fourth columns
  List<dynamic> timeStampColumn = []; // Col 0
  List<dynamic> minColumn = []; // col 1
  List<dynamic> maxColumn = []; // col 2
  List<dynamic> avgColumn = []; // col 3
  List<dynamic> peak2PeakColumn = []; // col 5
  for (List<dynamic> row in csvTable.skip(2)) {
    timeStampColumn.add(row[0]);
    minColumn.add(row[1]);
    maxColumn.add(row[2]);
    avgColumn.add(row[3]);
    peak2PeakColumn.add(row[5]);
  }

  // Do something with the extracted data
  debugPrint('First column: $timeStampColumn');
  debugPrint('Avg column: $avgColumn');
}
