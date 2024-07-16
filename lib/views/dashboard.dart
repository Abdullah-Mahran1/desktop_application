import 'package:desktop_application/const/constants.dart';
import 'package:desktop_application/cubits/ch_selector_cubit.dart';
import 'package:desktop_application/data_handling/graph_data_processing.dart';
import 'package:desktop_application/models/data_entry.dart';
import 'package:desktop_application/widgets/ch_selector_text_button.dart';
import 'package:desktop_application/widgets/sf_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  late Future<List<DataEntry>> _graphDataFuture;

  @override
  void initState() {
    super.initState();
    _graphDataFuture = loadData();
  }

  Future<List<DataEntry>> loadData() async {
    List<DataEntry> graphData = await loadGraphData(context: context);
    debugPrint('graphData loaded successfully');
    return graphData;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: defaultPadding),
          const Text('Wise 750 Dashboard',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: defaultPadding),
          const ChSelectorPanel(),
          const SizedBox(height: defaultPadding),
          FutureBuilder<List<DataEntry>>(
            future: _graphDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                debugPrint('snapShot is loading');
                return const Center(
                    child:
                        Text('\n\nLoading...') /*CircularProgressIndicator()*/);
              } else if (snapshot.hasError) {
                debugPrint('snapShot threw an error');
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                debugPrint('snapShot loaded successfully');
                return SfLineChart(
                  chartData: snapshot.data!,
                  // context: context,
                  // flSpots: snapshot.data!,
                  // graphXView: context.read<SettingsCubit>().state.graphXView,
                );
              }
            },
          ),
        ]),
      ),
    );
  }
}

class ChSelectorPanel extends StatelessWidget {
  const ChSelectorPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: const Color(secondBackgroundColor),
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8)),
        child: BlocProvider<ChSelectorCubit>(
          create: (context) => ChSelectorCubit(),
          child: BlocBuilder<ChSelectorCubit, ChSelectorState>(
            builder: (context, state) {
              return Row(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2, vertical: 2),
                  child: Text('Which Channels to monitor?',
                      style: TextStyle(color: Color(blackColor))),
                ),
                const Spacer(),
                ChSelectorTextButton(
                    color: const Color(ch0Color),
                    index: 0,
                    isSelected: (BlocProvider.of<ChSelectorCubit>(context)
                        .selectedChannels[0])),
                ChSelectorTextButton(
                    color: const Color(ch1Color),
                    index: 1,
                    isSelected: (BlocProvider.of<ChSelectorCubit>(context)
                        .selectedChannels[1])),
                ChSelectorTextButton(
                  color: const Color(ch2Color),
                  index: 2,
                  isSelected: (BlocProvider.of<ChSelectorCubit>(context)
                      .selectedChannels[2]),
                ),
                ChSelectorTextButton(
                  color: const Color(ch3Color),
                  index: 3,
                  isSelected: (BlocProvider.of<ChSelectorCubit>(context)
                      .selectedChannels[3]),
                ),
                const SizedBox(
                  width: defaultPadding / 2,
                )
              ]);
            },
          ),
        ));
  }
}
