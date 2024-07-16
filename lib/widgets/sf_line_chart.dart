import 'package:desktop_application/cubits/settings_cubit/settings_cubit.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SfLineChart extends StatelessWidget {
  final List<DataEntry> chartData;
  const SfLineChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    GraphXView xScale = context.read<SettingsCubit>().state.graphXView;
    debugPrint('dataEntry dateTime: ${chartData.first.timeValue}');

    return SfCartesianChart(
      series: <CartesianSeries>[
        LineSeries<DataEntry, DateTime>(
          dataSource: chartData,
          xValueMapper: (DataEntry entry, _) => entry.dateTime,
          yValueMapper: (DataEntry entry, _) => entry.peak2Peak,
        )
      ],
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat('mm:ss'),
        intervalType: DateTimeIntervalType.seconds,
        interval: 1,
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          // Convert the numeric value back to DateTime
          DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(details.value.toInt());
          String formattedValue = DataEntry.generateLabel(dateTime, xScale);
          return ChartAxisLabel(
              formattedValue, const TextStyle(color: Colors.black));
        },
      ),
      primaryYAxis: NumericAxis(
              minimum: -5,
              maximum: 5,
              interval: 1,
            ),
    );
  }
}
