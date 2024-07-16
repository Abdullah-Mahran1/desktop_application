import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/models/alert_model.dart';
import 'package:desktop_application/widgets/alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class AlertsSection extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  AlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 20,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: defaultPadding),
            const Text('Recent Alerts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: defaultPadding),
            ValueListenableBuilder(
              valueListenable:
                  Hive.box<AlertModel>('alertsWiseDashboard').listenable(),
              builder: (context, Box<AlertModel> box, _) {
                var alerts = box.values.toList();
                return SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Scrollbar(
                    thickness: 6,
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: ListView.builder(
                      reverse: true,
                      itemCount: alerts.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return AlertWidget(alert: alerts[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
