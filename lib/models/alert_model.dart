import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'alert_model.g.dart';

@HiveType(typeId: 0)
class AlertModel extends HiveObject {
  @HiveField(0)
  final IconData alertIcon = Icons.warning;

  @HiveField(1)
  final String errMsg;

  @HiveField(2)
  final String timeDate;

  AlertModel({required this.errMsg, DateTime? dateTime})
      : timeDate = (dateTime ?? DateTime.now()).toString().split('.')[0];
}
