import 'dart:io';

import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/data_handling/alerts_management.dart';
import 'package:desktop_application/data_handling/csv_communication.dart';
import 'package:desktop_application/models/alert_model.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSingleton {
  // Private constructor
  DataSingleton._privateConstructor();

  // Static instance
  static final DataSingleton _instance = DataSingleton._privateConstructor();

  // Factory constructor to return the instance
  factory DataSingleton() {
    return _instance;
  }

  // List to store DataEntry objects
  List<DataEntry>? _dataEntries;
  DateTime? startingDateTime;
  bool? isDeviceConnected;
  bool? isLiveGraph;
  // SharedPreferences instance
  SharedPreferences? _settings;
  // Public variable to store 'xView'
  String? xView; // Initialize with default value
  double defaultAlertValue = 1.0;
  final Map<String, double> chAlerts = {
    'Ch0 Alert': 1.0,
    'Ch1 Alert': 1.0,
    'Ch2 Alert': 1.0,
    'Ch3 Alert': 1.0,
  };

  // Initialize SharedPreferences and load 'xView'
  Future<void> initPreferences() async {
    _settings = await SharedPreferences.getInstance();
    xView = _settings?.getString('xView');
    if (xView == null) {
      await _settings!.setString('xView', 'MINUTE');
      xView = _settings?.getString('xView');
    }
    for (String key in chAlerts.keys) {
      double? alertValue = _settings?.getDouble(key);
      if (alertValue == null) {
        await _settings!.setDouble(key, defaultAlertValue);
        alertValue = _settings?.getDouble(key);
      }
    }

    startingDateTime = _settings!.getString('startingDateTime') == null
        ? null
        : DateTime.parse(_settings!.getString('startingDateTime')!);

    isLiveGraph = _settings!.getBool('isLiveGraph') ?? false;
  }

  Future<String?> getLastFileName() async {
    final directory = Directory('${Directory.current.path}/assets/data');
    final files = await directory
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.csv'))
        .toList();

    if (files.isEmpty) return null;

    files
        .sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    String lastFileName = files.first.path;
    return lastFileName;
  }

  // Getter for the data entries list
  Future<List<DataEntry>> getDataEntries(
    BuildContext context,
    String? month,
  ) async {
    if (month == null) {
      month = await getLastFileName();
      if (month == null) {
        AlertsManager.addAlert(
            AlertModel(errMsg: 'No Files Found in the stored data'));
      } else {
        _dataEntries ??= await loadFromCsv(month, context: context);
      }
    } else {
      _dataEntries ??= await loadFromCsv(month, context: context);
    }

    // Load xView from SharedPreferences
    await initPreferences();

    // Filter data based on startingDateTime
    List<DataEntry> filteredEntries = _dataEntries!;
    if (startingDateTime != null) {
      filteredEntries = filteredEntries
          .where((entry) => entry.dateTime.isAfter(startingDateTime!))
          .toList();

      // Determine the end date based on xView
      DateTime? endDateTime = startingDateTime;
      switch (GraphXView.values
          .firstWhere((e) => e.toString().split('.').last == xView)) {
        case GraphXView.MINUTE:
          endDateTime = endDateTime!.add(const Duration(minutes: 1));
          break;
        case GraphXView.HOUR:
          endDateTime = endDateTime!.add(const Duration(hours: 1));
          break;
        case GraphXView.SIX_HOURS:
          endDateTime = endDateTime!.add(const Duration(hours: 6));
          break;
        case GraphXView.DAY:
          endDateTime = endDateTime!.add(const Duration(days: 1));
          break;
        case GraphXView.SIX_DAYS:
          endDateTime = endDateTime!.add(const Duration(days: 6));
          break;
      }

      // Further filter data to include only entries up to endDateTime
      filteredEntries = filteredEntries
          .where((entry) => entry.dateTime.isBefore(endDateTime!))
          .toList();
    }
    return filteredEntries;
  }
}
