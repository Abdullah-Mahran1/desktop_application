import 'dart:io';

import 'package:csv/csv.dart';
import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/const/data_singleton.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
Methods of the file:
saveToCsv : saves List<DataEntry> to csv file
loadFromCsv : returns List<DataEntry> from csv file
removeExcessData: loadFromCsv uses to split loaded data to retrun only data needed to display from graph


*/
List<DataEntry> serverData = [];

Future<bool> saveToCsv(List<DataEntry>? dataEntries) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (dataEntries == null) {
    debugPrint('Hala Belkhamees: ');
    dataEntries = serverData;
  }
  try {
    var file = File(
        'assets/data/${dataEntries[0].dateTime.toString().substring(0, 7)}.csv');
    // debugPrint('csv exists? ${file.existsSync()}');
    List<List> csvData;
    if (file.existsSync()) {
      csvData = const CsvToListConverter().convert(await file.readAsString());
      debugPrint('csv - saving to existing: ${file.path}');
    } else {
      debugPrint('csv - saving to newly-created: ${file.path}');
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

Future<List<DataEntry>> loadFromCsv(String month,
    {required BuildContext context}) async {
  try {
    debugPrint('csv - loading from $month');
    var file = File(month);
    if (!file.existsSync()) {
      debugPrint('File does not exist: ${file.path}, loadFromCsv() error');
      return [];
    }
    // else {
    // debugPrint('opened file');}

    String contents = await file.readAsString();
    List<List<dynamic>> csvData = const CsvToListConverter().convert(contents);

    // remove labels
    if (csvData.isNotEmpty && csvData[0][0] == 'TimeStamp') {
      csvData.removeAt(0);
    }

    List<DataEntry> dataEntries = csvData.map((row) {
      return DataEntry(
        dateTime: DateTime.parse(row[0].toString()),
        min: double.parse(row[1].toString()),
        max: double.parse(row[2].toString()),
        average: double.parse(row[3].toString()),
        peak2Peak: double.parse(row[4].toString()),
      );
    }).toList();

    debugPrint('Loaded ${dataEntries.length} entries from CSV');
    serverData.addAll(dataEntries);
    return dataEntries;
    // return removeExcessData(
    //         dataEntries: dataEntries, doNullIfLess: false, context: context) ??
    //     [];
  } catch (e) {
    debugPrint('Error reading CSV: ${e.toString()}');
    return [];
  }
}

List<DataEntry>? removeExcessData(
    {required List<DataEntry> dataEntries,
    bool doNullIfLess = true,
    required BuildContext context}) {
  if (dataEntries.isEmpty) return null;

  int requiredValue;
  Duration requiredDuration;
  GraphXView currentXView =
      GraphXView.values.byName(DataSingleton().xView ?? 'MINUTE');

  switch (currentXView) {
    case GraphXView.MINUTE:
      requiredValue = 1;
      requiredDuration = const Duration(minutes: 1);
      break;
    case GraphXView.HOUR:
      requiredValue = 1;
      requiredDuration = const Duration(hours: 1);
      break;
    case GraphXView.SIX_HOURS:
      requiredValue = 6;
      requiredDuration = const Duration(hours: 6);
      break;
    case GraphXView.DAY:
      requiredValue = 1;
      requiredDuration = const Duration(days: 1);
      break;
    case GraphXView.SIX_DAYS:
      requiredValue = 6;
      requiredDuration = const Duration(days: 6);
      break;
  }

  Duration actualDuration =
      dataEntries.last.dateTime.difference(dataEntries.first.dateTime);
  bool isEnoughData;

  switch (currentXView) {
    case GraphXView.MINUTE:
      isEnoughData = actualDuration.inMinutes >= requiredValue;
      break;
    case GraphXView.HOUR:
    case GraphXView.SIX_HOURS:
      isEnoughData = actualDuration.inHours >= requiredValue;
      break;
    case GraphXView.DAY:
    case GraphXView.SIX_DAYS:
      isEnoughData = actualDuration.inDays >= requiredValue;
      break;
  }

  if (!isEnoughData) {
    return doNullIfLess ? null : dataEntries;
  }

  DateTime endTime = dataEntries.last.dateTime;
  DateTime startTime = endTime.subtract(requiredDuration);

  debugPrint('removed excess data');
  return dataEntries
      .where((entry) => entry.dateTime.isAfter(startTime))
      .toList();
}
