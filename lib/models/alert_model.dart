import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'alert_model.g.dart';

@HiveType(typeId: 0)
class AlertModel extends HiveObject {
  @HiveField(0)
  final IconData alertIcon;

  @HiveField(1)
  final String errMsg;

  @HiveField(2)
  final String timeDate;

  AlertModel({
    required this.alertIcon,
    required this.errMsg,
    required this.timeDate,
  });
}
