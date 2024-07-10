import 'dart:io';

import 'package:csv/csv.dart';
import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<bool> saveToCsv(List<DataEntry> dataEntries) async {
  try {
    var file = File(
        'assets/data/${dataEntries[0].dateTime.toString().substring(0, 7)}.csv');
    // debugPrint('csv exists? ${file.existsSync()}');
    List<List> csvData;
    if (file.existsSync()) {
      csvData = const CsvToListConverter().convert(await file.readAsString());
    } else {
      csvData = <List<dynamic>>[];
      csvData.add([
        ['TimeStamp', 'min', 'max', 'avg', 'peak2peak']
      ]);
    }
    // debugPrint('csv exists? ${file.existsSync()}');

    csvData.addAll(dataEntries.map((it) => it.toCSVRow()));
    String csv = const ListToCsvConverter().convert(csvData);
    await file.writeAsString(csv);
    debugPrint('Saved ✔');
    return true;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

Future<List<DataEntry>> loadFromCsv(String month) async {
  try {
    var file = File('assets/data/$month.csv');
    if (!file.existsSync()) {
      debugPrint('File does not exist: ${file.path}');
      return [];
    }

    String contents = await file.readAsString();
    List<List<dynamic>> csvData = const CsvToListConverter().convert(contents);

    // Remove header if present
    if (csvData.isNotEmpty && csvData[0][0] == 'TimeStamp') {
      csvData.removeAt(0);
    }

    List<DataEntry> dataEntries = csvData.map((row) {
      return DataEntry(
        dateTime: DateTime.parse(row[0]),
        min: double.parse(row[1]),
        max: double.parse(row[2]),
        average: double.parse(row[3]),
        peak2Peak: double.parse(row[4]),
      );
    }).toList();

    debugPrint('Loaded ${dataEntries.length} entries from CSV');
    return await removeExcessData(
      dataEntries: dataEntries,
      doNullIfLess: false,
    )!;
  } catch (e) {
    debugPrint('Error reading CSV: ${e.toString()}');
    return [];
  }
}

// Main function to remove excess data
List<DataEntry>? removeExcessData({
  required List<DataEntry> dataEntries,
  bool doNullIfLess = true,
}) {
  if (dataEntries.isEmpty) return null;

  TimeSpanRequirement requirement = getRequiredTimeSpan(currentXView);
  bool isEnoughData =
      isTimeSpanSufficient(dataEntries.first, dataEntries.last, requirement);

  if (!isEnoughData) {
    return doNullIfLess ? null : dataEntries;
  }

  // If we have more data than needed, trim it
  return trimDataToTimeSpan(dataEntries, requirement);
}

class TimeSpanRequirement {
  final int value;
  final GraphXView unit;

  TimeSpanRequirement(this.value, this.unit);
}

// Updated function to get the required time span for each GraphXView
TimeSpanRequirement getRequiredTimeSpan(GraphXView view) {
  switch (view) {
    case GraphXView.MINUTE:
      return TimeSpanRequirement(1, GraphXView.MINUTE);
    case GraphXView.HOUR:
      return TimeSpanRequirement(1, GraphXView.HOUR);
    case GraphXView.SIX_HOURS:
      return TimeSpanRequirement(6, GraphXView.HOUR);
    case GraphXView.DAY:
      return TimeSpanRequirement(1, GraphXView.DAY);
    case GraphXView.SIX_DAYS:
      return TimeSpanRequirement(6, GraphXView.DAY);
  }
}

// Updated function to calculate the time difference based on the required unit
bool isTimeSpanSufficient(
    DataEntry first, DataEntry last, TimeSpanRequirement requirement) {
  Duration difference = last.dateTime.difference(first.dateTime);
  switch (requirement.unit) {
    case GraphXView.MINUTE:
      return difference.inMinutes >= requirement.value;
    case GraphXView.HOUR:
    case GraphXView.SIX_HOURS:
      return difference.inHours >= requirement.value;
    case GraphXView.DAY:
    case GraphXView.SIX_DAYS:
      return difference.inDays >= requirement.value;
  }
}

// Updated function to trim data to the required time span
List<DataEntry> trimDataToTimeSpan(
    List<DataEntry> dataEntries, TimeSpanRequirement requirement) {
  DateTime endTime = dataEntries.last.dateTime;
  DateTime startTime;

  switch (requirement.unit) {
    case GraphXView.MINUTE:
      startTime = endTime.subtract(Duration(minutes: requirement.value));
      break;
    case GraphXView.HOUR:
    case GraphXView.SIX_HOURS:
      startTime = endTime.subtract(Duration(hours: requirement.value));
      break;
    case GraphXView.DAY:
    case GraphXView.SIX_DAYS:
      startTime = endTime.subtract(Duration(days: requirement.value));
      break;
  }

  return dataEntries
      .where((entry) => entry.dateTime.isAfter(startTime))
      .toList();
}



// Future<List<List<dynamic>>?> loadFromCsv(String filePath) async {
//   // TODO: prepare for enter-day data-loading (load multiple days at once)
//   // Load the CSV file
//   String csvData;
//   try {
//     csvData = await rootBundle.loadString(filePath);
//   } catch (e) {
//     debugPrint('Error loading CSV file: $e');
//     // Handle the error, maybe show a dialog to the user
//     return null;
//   }
//   // Parse the CSV data
//   List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);

//   // // Extract the first and fourth columns
//   // List<dynamic> timeStampColumn = []; // Col 0
//   // List<dynamic> minColumn = []; // col 1
//   // List<dynamic> maxColumn = []; // col 2
//   // List<dynamic> avgColumn = []; // col 3
//   // List<dynamic> peak2PeakColumn = []; // col 5

//   // for (List<dynamic> row in csvTable.skip(1)) {
//   //   timeStampColumn.add(row[0]);
//   //   minColumn.add(row[1]);
//   //   maxColumn.add(row[2]);
//   //   avgColumn.add(row[3]);
//   //   peak2PeakColumn.add(row[4]);
//   // }

//   // // Do something with the extracted data
//   // debugPrint('First column: $timeStampColumn');
//   // debugPrint('Avg column: $avgColumn');
//   return csvTable;
// }