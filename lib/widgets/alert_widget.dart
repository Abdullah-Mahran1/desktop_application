import 'package:desktop_application/models/alert_model.dart';
import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final AlertModel alert;

  const AlertWidget({Key? key, required this.alert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(alert.alertIcon, color: Colors.yellow[700]),
      title: Text(alert.errMsg),
      subtitle: Text(alert.timeDate.toString()),
    );
  }
}
