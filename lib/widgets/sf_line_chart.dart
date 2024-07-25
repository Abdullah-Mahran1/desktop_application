import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/const/data_singleton.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

DateFormat formatDateTime(GraphXView xScale) {
  switch (xScale) {
    case GraphXView.MINUTE:
      return DateFormat('mm:ss');
    case GraphXView.HOUR:
    case GraphXView.SIX_HOURS:
      return DateFormat('hh:mm');
    case GraphXView.DAY:
    case GraphXView.SIX_DAYS:
      return DateFormat('dd:hh');
    default:
      return DateFormat('mm:ss');
  }
}

class SfChart extends StatelessWidget {
  final List<DataEntry> chartData;
  late GraphXView xScale;
  SfChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    xScale = GraphXView.values.byName(DataSingleton().xView ?? 'MINUTE');
    debugPrint(
        '''dataEntry dateTime: ${chartData.first.timeValue}, dataLen: ${chartData.length}
        DateFormat: ${DateFormat('dd-hh:mm').format(chartData.first.dateTime)}
        ''');
    if (DataSingleton().isLiveGraph ?? false) {
      return LiveChart(chartData.sublist(0, 10), xScale);
    } else {
      return SfCartesianChart(
        series: <CartesianSeries>[
          LineSeries<DataEntry, DateTime>(
            dataSource: chartData,
            xValueMapper: (DataEntry entry, _) => entry.dateTime,
            yValueMapper: (DataEntry entry, _) => entry.peak2Peak,
          )
        ],
        title: ChartTitle(
            text: 'Current time label: ${formatDateTime(xScale).pattern}'),
        primaryXAxis: DateTimeAxis(
          dateFormat: formatDateTime(xScale),
          intervalType: DateTimeIntervalType.auto,

          // interval: chartData.length.toDouble() / 10,
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            // Convert the numeric value back to DateTime
            DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(details.value.toInt());
            String formattedValue = DataEntry.generateLabel(dateTime, xScale);
            return ChartAxisLabel(
                formattedValue, const TextStyle(color: Colors.black));
          },
        ),
        primaryYAxis: const NumericAxis(
          minimum: -1,
          maximum: 12,
          interval: 1,
        ),
      );
    }
  }
}

class LiveChart extends StatelessWidget {
  List<DataEntry> chartData;
  GraphXView xScale;
  LiveChart(this.chartData, this.xScale, {super.key});
  late ChartSeriesController _chartSeriesController;

  void appendData(DataEntry dataEntry) {
    chartData.add(dataEntry);
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      series: <CartesianSeries>[
        LineSeries<DataEntry, DateTime>(
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController = controller;
          },
          dataSource: chartData,
          xValueMapper: (DataEntry entry, _) => entry.dateTime,
          yValueMapper: (DataEntry entry, _) => entry.peak2Peak,
        )
      ],
      title: ChartTitle(
          text: 'Current time label: ${formatDateTime(xScale).pattern}'),
      primaryXAxis: DateTimeAxis(
        dateFormat: formatDateTime(xScale),
        intervalType: DateTimeIntervalType.auto,

        // interval: chartData.length.toDouble() / 10,
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          // Convert the numeric value back to DateTime
          DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(details.value.toInt());
          String formattedValue = DataEntry.generateLabel(dateTime, xScale);
          return ChartAxisLabel(
              formattedValue, const TextStyle(color: Colors.black));
        },
      ),
      primaryYAxis: const NumericAxis(
        minimum: -1,
        maximum: 12,
        interval: 1,
      ),
    );
  }
}
