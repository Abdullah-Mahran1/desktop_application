import 'package:desktop_application/models/alert_model.dart';
import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final AlertModel alert;

  const AlertWidget({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(alert.alertIcon, color: Colors.yellow[700]),
      title: Text(alert.errMsg),
      subtitle: Text(alert.timeDate.toString()),
    );
  }
}
