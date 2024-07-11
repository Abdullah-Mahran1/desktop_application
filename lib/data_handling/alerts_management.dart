import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/alert_model.dart';

class AlertsManager {
  static Box<AlertModel> get _box =>
      Hive.box<AlertModel>('alertsWiseDashboard');

  static Future<void> addAlert(AlertModel alert) async {
    await _box.add(alert);
    debugPrint('An alert was added');
  }

  static List<AlertModel> getAllAlerts() {
    List<AlertModel> alerts = _box.values.toList();
    debugPrint('read ${alerts.length} alerts successfully');

    return alerts;
  }

  static Future<void> deleteAlert(AlertModel alert) async {
    await alert.delete();
  }
}
